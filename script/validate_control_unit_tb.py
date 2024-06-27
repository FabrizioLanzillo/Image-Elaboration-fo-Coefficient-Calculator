import os

def compute_fo(alpha, previous_pixel, pixel):
    return alpha * previous_pixel + (8 - alpha) * pixel

def main():
    alpha = 2
    file_path = os.path.join('..', 'conf_files', 'control_unit_input.txt')
    with open(file_path, 'r') as f:
        lines = f.readlines()
        for line in lines:
            pixel_in_ext, previous_pixel_in_ext, i_current_value_in_ext, j_current_value_in_ext = map(int, line.strip().split(','))
            if i_current_value_in_ext < 4:
                if i_current_value_in_ext == 0:
                    fo_out_ext = 0
                else:
                    fo_out_ext = compute_fo(alpha, previous_pixel_in_ext, pixel_in_ext)
                i_next_value_out_ext = i_current_value_in_ext + 1
                j_next_value_out_ext = j_current_value_in_ext
            else:
                if j_current_value_in_ext < 4:
                    j_next_value_out_ext = j_current_value_in_ext + 1
                else:
                    j_next_value_out_ext = 0
                i_next_value_out_ext = 0
                fo_out_ext = 0
            print(f'i_next_value: {i_next_value_out_ext}, j_next_value: {j_next_value_out_ext}, fo: {fo_out_ext}')

if __name__ == "__main__":
    main()
