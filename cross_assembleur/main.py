import sys

def output_instructions_binary(instructions):
    file = open("STD_LOGIC_VECTOR_output", "w")
    file.write("(")
    for index, instruction in enumerate(instructions):
        string_instruction = str(index) + "=>"
        string_instruction+= "\""
        op = f'{int(instruction[0]):08b}'
        arg1 = f'{int(instruction[1]):08b}'
        arg2 = f'{int(instruction[2]):08b}'
        arg3 = f'{int(instruction[3]):08b}'
        string_instruction += op + arg1 + arg2 + arg3
        string_instruction += "\", "
        file.write(string_instruction)
    file.write("others => \"00000000000000000000000000000000\")")
    file.close()


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Please only input one file name")
        exit(0)

    filename = sys.argv[1]
    f = open(filename, "r")
    lines = f.readlines()
    lines = [line.strip() for line in lines]
    instructions = [line.split(" ") for line in lines]

    output_instructions_binary(instructions)
    f.close()




