import os
import numpy as np

def compute_fo_decimal(alpha, previous_pixel, pixel):
    if alpha != 0:
        return alpha * previous_pixel + (1 - alpha) * pixel
    else:
        return 0

def compute_fo_fixed_point_arithmetic(alpha, previous_pixel, pixel):
    if alpha != 0:
        return alpha * previous_pixel + (8 - alpha) * pixel
    else:
        return 0

def convert_decimal_to_fixed_point(decimal_number, bit_length):
    return int(decimal_number * (2**bit_length))

def main():
    file_path = os.path.join('..', 'conf_files', 'control_unit_input.txt')
    with open(file_path, 'r') as f:
        lines = f.readlines()
        alpha_decimal = float(lines[0].strip())
        alpha_fixed_point = convert_decimal_to_fixed_point(alpha_decimal, 3)
        NCol = int(lines[1].strip())
        NRow = int(lines[2].strip())
        matrix = np.array([int(x) for x in lines[3].split(',')]).reshape(NCol, NRow).T
        print("---------------------------------------------------")
        print("[Conf]")
        print(f"\talpha_decimal = {alpha_decimal};")
        print(f"\talpha_fixed_point = {alpha_fixed_point};")
        print("---------------------------------------------------")
        for j in range(NCol):
            for i in range(NRow):
                pixel = matrix[i][j]
                previous_pixel = matrix[i-1][j] if i > 0 else 0
                if i == 0:
                    fo_fixed_point = 0
                    fo_decimal = 0
                else:
                    fo_fixed_point = compute_fo_fixed_point_arithmetic(alpha_fixed_point, previous_pixel, pixel)
                    fo_decimal = compute_fo_decimal(alpha_decimal, previous_pixel, pixel)
                print("[Output Control Unit]")
                print("IN:")
                print(f"\ti_current_value = {i}")
                print(f"\tj_current_value = {j}")
                print(f"\tprevious_pixel = {previous_pixel}")
                print(f"\tpixel = {pixel}")
                print("OUT:")
                print(f"\tfo_decimal = {fo_decimal}")
                print(f"\tfo_fixed_point = {fo_fixed_point}")
                print(f"\tfo_decimal_converted_to_fixed_point = {convert_decimal_to_fixed_point(fo_decimal, 3)}")
                print(f"\ti_next_value_out_ext = {(i + 1) % NRow}")
                print(f"\tj_next_value_out_ext = {(j + 1) % NCol if i + 1 == NRow else j}")
                print("---------------------------------------------------")

if __name__ == "__main__":
    main()
