import os
import numpy as np

def compute_fo(alpha, previous_pixel, pixel):
    return alpha * previous_pixel + (8 - alpha) * pixel

def main():
    file_path = os.path.join('..', 'conf_files', 'control_unit_input.txt')
    with open(file_path, 'r') as f:
        lines = f.readlines()
        alpha = int(lines[0].strip())
        NCol = int(lines[1].strip())
        NRow = int(lines[2].strip())
        matrix = np.array([int(x) for x in lines[3].split(',')]).reshape(NCol, NRow).T
        print("------------------------------")
        print("[Conf]")
        print(f"alpha = {alpha};")
        print("------------------------------")
        for j in range(NCol):
            for i in range(NRow):
                pixel_in_ext = matrix[i][j]
                previous_pixel_in_ext = matrix[i-1][j] if i > 0 else 0
                if i == 0:
                    fo_out_ext = 0
                else:
                    fo_out_ext = compute_fo(alpha, previous_pixel_in_ext, pixel_in_ext)
                print("------------------------------")
                print("[Output Control Unit]")
                print("- IN:")
                print(f"i_current_value_in_ext = {i}")
                print(f"j_current_value_in_ext = {j}")
                print(f"previous_pixel_in_ext = {previous_pixel_in_ext}")
                print(f"pixel_in_ext = {pixel_in_ext}")
                print("- OUT:")
                print(f"fo_out_ext = {fo_out_ext}")
                print(f"i_next_value_out_ext = {(i + 1) % NRow}")
                print(f"j_next_value_out_ext = {(j + 1) % NCol if i + 1 == NRow else j}")
                print("------------------------------")

if __name__ == "__main__":
    main()
