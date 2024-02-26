import os


def count_dart_files(directory):
    dart_files = [file for file in os.listdir(directory) if file.endswith(".dart")]
    return len(dart_files)


def count_lines_and_chars(directory):
    total_lines = 0
    total_chars = 0

    for root, dirs, files in os.walk(directory):
        if "lib" in root:
            for file in files:
                if file.endswith(".dart"):
                    file_path = os.path.join(root, file)
                    with open(file_path, "r", encoding="utf-8") as f:
                        lines = f.readlines()
                        total_lines += len(lines)
                        total_chars += sum(len(line) for line in lines)

    return total_lines, total_chars


if __name__ == "__main__":
    flutter_project_dir = os.getcwd()

    dart_file_count = count_dart_files(flutter_project_dir)
    total_lines, total_chars = count_lines_and_chars(flutter_project_dir)

    print(f"Number of Dart files: {dart_file_count}")
    print(f"Total number of lines in 'lib' folder: {total_lines}")
    print(f"Total number of characters in 'lib' folder: {total_chars}")
