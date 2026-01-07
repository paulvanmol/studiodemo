
import os

# === CONFIGURATION ===
# If you want to overwrite originals, set dst_dir = src_dir
src_dir = r"/home/student/demo/project1_latin1"
dst_dir = r"/home/student/demo/project1_utf8"
add_bom = False  # Set True only if a specific tool requires a UTF-8 BOM

def detect_encoding(path: str) -> str:
    """
    Detect the most likely text encoding for a SAS file.

    Strategy:
      1) BOM detection for UTF-8/UTF-16
      2) Try UTF-8 (no BOM)
      3) Try Windows-1252 (cp1252)
      4) Try ISO-8859-15 (latin-9)
      5) Fallback to ISO-8859-1 (latin-1)

    Returns a Python codec name suitable for open(..., encoding=...).
    """
    with open(path, 'rb') as f:
        data = f.read(256 * 1024)  # sample up to 256KB

    # 1) BOM checks
    if data.startswith(b'\xef\xbb\xbf'):
        return 'utf-8-sig'  # UTF-8 with BOM
    if data.startswith(b'\xff\xfe') or data.startswith(b'\xfe\xff'):
        # Likely UTF-16 (LE/BE); Python will handle normalization
        return 'utf-16'

    # 2) Try UTF-8 (no BOM)
    try:
        data.decode('utf-8')
        return 'utf-8'
    except UnicodeDecodeError:
        pass

    # 3) Try Windows-1252
    try:
        data.decode('cp1252')
        return 'cp1252'
    except UnicodeDecodeError:
        pass

    # 4) Try ISO-8859-15
    try:
        data.decode('iso-8859-15')
        return 'iso-8859-15'
    except UnicodeDecodeError:
        pass

    # 5) Fallback: latin-1 (never fails)
    return 'latin-1'


def convert_file(src_path: str, dst_path: str) -> tuple[str, bool]:
    """
    Convert a single file to UTF-8 (optionally with BOM).
    Returns (detected_encoding, converted_flag).
    converted_flag = True if it was legacy and re-encoded; False if already UTF-8 and just normalized.
    """
    detected = detect_encoding(src_path)

    # Read using the detected encoding
    with open(src_path, 'r', encoding=detected, newline='') as f_in:
        text = f_in.read()

    # Choose UTF-8 output (with or without BOM)
    encoding_out = 'utf-8-sig' if add_bom else 'utf-8'

    # Ensure destination directory exists
    os.makedirs(os.path.dirname(dst_path), exist_ok=True)

    # Write as UTF-8; preserve newline characters as-is
    with open(dst_path, 'w', encoding=encoding_out, newline='') as f_out:
        f_out.write(text)

    # Consider conversion "legacy" if source wasn't utf-8 or utf-8-sig
    converted_flag = detected not in ('utf-8', 'utf-8-sig')
    return (detected, converted_flag)


def batch_convert(src_root: str, dst_root: str) -> None:
    total = 0
    converted = 0
    normalized = 0  # already UTF-8 but re-written (e.g., strip BOM or mirror)
    errors = 0
    by_encoding: dict[str, int] = {}

    for root, _, files in os.walk(src_root):
        for name in files:
            if not name.lower().endswith(".sas"):
                continue

            total += 1
            src_path = os.path.join(root, name)
            rel_path = os.path.relpath(src_path, src_root)
            dst_path = os.path.join(dst_root, rel_path)

            try:
                detected, did_convert = convert_file(src_path, dst_path)
                by_encoding[detected] = by_encoding.get(detected, 0) + 1
                if did_convert:
                    print(f"Converted ({detected}) -> UTF-8: {src_path} -> {dst_path}")
                    converted += 1
                else:
                    print(f"Copied/normalized ({detected}) as UTF-8: {src_path} -> {dst_path}")
                    normalized += 1
            except Exception as e:
                print(f"ERROR processing {src_path}: {e}")
                errors += 1

    print("\n=== Summary ===")
    print(f"Source directory          : {src_root}")
    print(f"Destination directory     : {dst_root} {'(in-place overwrite)' if dst_root == src_root else ''}")
    print(f"Total .sas files found    : {total}")
    print(f"Re-encoded to UTF-8       : {converted}")
    print(f"Normalized (already UTF-8): {normalized}")
    print(f"Errors                    : {errors}")
    print("Detected encodings count  :")
    for enc, n in sorted(by_encoding.items(), key=lambda kv: (-kv[1], kv[0])):
        print(f"  {enc:>12} : {n}")

if __name__ == "__main__":
    print("Starting dynamic encoding detection and conversion to UTF-8...")
    print(f"Source     : {src_dir}")
    print(f"Destination: {dst_dir} {'(in-place overwrite)' if dst_dir == src_dir else ''}")
    print(f"UTF-8 BOM  : {'ON' if add_bom else 'OFF'}")
    batch_convert(src_dir, dst_dir)
   