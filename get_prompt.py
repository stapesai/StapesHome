import os
from prompt_toolkit import PromptSession
from prompt_toolkit.key_binding import KeyBindings
from prompt_toolkit.application import Application
from prompt_toolkit.layout import Layout
from prompt_toolkit.layout.controls import BufferControl
from prompt_toolkit.layout.containers import Window, HSplit
from prompt_toolkit.buffer import Buffer
from prompt_toolkit.styles import Style
from prompt_toolkit.layout.dimension import Dimension
from prompt_toolkit.application.current import get_app

def list_files(folders, allowed_extensions):
    files = []
    for folder_path in folders:
        for root, _, filenames in os.walk(folder_path):
            for file in filenames:
                if any(file.endswith(ext) for ext in allowed_extensions):
                    files.append(os.path.join(root, file))
    return files

def select_files(files):
    selected_files = set()
    bindings = KeyBindings()
    cursor_position = 0

    def update_prompt_text():
        return '\n'.join(
            f"{'>' if i == cursor_position else ' '} [{'x' if i in selected_files else ' '}] {i + 1}: {file}"
            for i, file in enumerate(files)
        )

    @bindings.add('up')
    def move_up(event):
        nonlocal cursor_position
        if cursor_position > 0:
            cursor_position -= 1
        # Update buffer content
        buffer.text = update_prompt_text()

    @bindings.add('down')
    def move_down(event):
        nonlocal cursor_position
        if cursor_position < len(files) - 1:
            cursor_position += 1
        # Update buffer content
        buffer.text = update_prompt_text()

    @bindings.add('space')
    def toggle_selection(event):
        nonlocal cursor_position
        if cursor_position in selected_files:
            selected_files.remove(cursor_position)
        else:
            selected_files.add(cursor_position)
        # Update prompt text
        buffer.text = update_prompt_text()

    @bindings.add('enter')
    def submit(event):
        event.app.exit()

    @bindings.add('c-q')
    @bindings.add('c-c')
    def handle_exit(event):
        event.app.exit()

    buffer = Buffer()
    buffer.text = update_prompt_text()

    # Create layout with a window that adjusts to the terminal size
    root_container = HSplit([Window(content=BufferControl(buffer=buffer), wrap_lines=True, height=Dimension())])
    
    # Create the application with the key bindings and layout
    app = Application(
        layout=Layout(root_container),
        key_bindings=bindings,
        full_screen=True,
    )

    try:
        app.run()
    except KeyboardInterrupt:
        print("\nProcess interrupted. Exiting...")
        return []

    return [files[i] for i in sorted(selected_files)]

def write_files_contents_to_text(folders, allowed_extensions, output_file):
    files = list_files(folders, allowed_extensions)
    if not files:
        print(f"No files with extensions {allowed_extensions} found in the specified folders.")
        return

    selected_files = select_files(files)
    if not selected_files:
        print("No files selected for output.")
        return

    with open(output_file, 'w') as outfile:
        for file_path in selected_files:
            with open(file_path, 'r') as infile:
                outfile.write(f"// File: {file_path}\n")
                outfile.write("/*\n")
                outfile.write(infile.read())
                outfile.write("\n*/\n\n\n\n\n")  # Add some space between file contents

if __name__ == "__main__":
    FOLDERS = ["lib"]
    ALLOWED_EXTENSIONS = [".dart"]
    output_file = "prompt.txt"

    write_files_contents_to_text(FOLDERS, ALLOWED_EXTENSIONS, output_file)
    print(f"Contents of selected files written to '{output_file}'")
