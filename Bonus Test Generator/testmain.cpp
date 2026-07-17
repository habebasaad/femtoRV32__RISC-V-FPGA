#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <random>
#include <map>
#include <iomanip>
#include <bitset>
#include <sstream>
#include <algorithm>
#include <filesystem>

class RISC_V_TestGenerator
{
private:
    std::mt19937 rng;
    std::uniform_int_distribution<int> reg_dist;
    std::uniform_int_distribution<int> imm_dist;
    std::uniform_int_distribution<int> op_dist;

    std::vector<std::string> assembly_lines;
    std::vector<std::string> binary_lines;
    std::vector<std::string> instruction_lines;

    bool initialization_done;
    std::vector<int> initialized_regs;

public:
    RISC_V_TestGenerator() : rng(std::random_device{}()),
                             reg_dist(1, 31),
                             imm_dist(-2048, 2047),
                             op_dist(0, 100),
                             initialization_done(false) {}

    std::string to_lower(const std::string &str)
    {
        std::string result = str;
        std::transform(result.begin(), result.end(), result.begin(), ::tolower);
        return result;
    }

    int random_reg_num(bool can_be_zero = true)
    {
        return can_be_zero ? (reg_dist(rng) - 1) : reg_dist(rng);
    }

    std::string random_reg(bool can_be_zero = true)
    {
        int reg = random_reg_num(can_be_zero);
        std::bitset<5> bits(reg);
        return bits.to_string();
    }

    int random_imm12_val()
    {
        return imm_dist(rng);
    }

    std::string random_imm12()
    {
        int imm = random_imm12_val();
        std::bitset<12> bits(imm & 0xFFF);
        return bits.to_string();
    }

    // Create directory for test files
    bool create_test_directory(const std::string& folder_name)
    {
        try {
            if (!std::filesystem::exists(folder_name)) {
                std::filesystem::create_directory(folder_name);
                std::cout << "Created directory: " << folder_name << std::endl;
            }
            return true;
        }
        catch (const std::exception& e) {
            std::cerr << "ERROR: Cannot create directory '" << folder_name << "': " << e.what() << std::endl;
            return false;
        }
    }

    // Generate fixed initialization instructions
    void generate_fixed_initialization()
    {
        if (initialization_done) return;
        
        std::cout << "Generating the 8 instructions" << std::endl;

        // First instruction: ADDI x0, x0, 0 (NOP)
        std::string binary_nop = "00000000000000000000000000010011";
        std::string assembly_nop = "addi x0, x0, 0";
        
        assembly_lines.push_back(assembly_nop);
        binary_lines.push_back(binary_nop);
        instruction_lines.push_back("Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly_nop + " | Binary: " + binary_nop);
        
        std::cout << "  " << instruction_lines.back() << std::endl;

        // Second instruction: ADDI x31, x0, 128
        // imm[11:0] = 128 = 00010000000
        // rd = 11111, rs1 = 00000, funct3 = 000, opcode = 0010011
        // Binary: 00001000000000000000111110010011
        std::string binary_x31 = "00001000000000000000111110010011";
        std::string assembly_x31 = "addi x31, x0, 128";
        
        assembly_lines.push_back(assembly_x31);
        binary_lines.push_back(binary_x31);
        instruction_lines.push_back("Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly_x31 + " | Binary: " + binary_x31);
        initialized_regs.push_back(31);
        
        std::cout << "  " << instruction_lines.back() << std::endl;
        
        initialization_done = true;
    }

    // Generate additional initialization instructions (ADDI to set up registers)
    void generate_additional_initialization(int num_init_instructions)
    {
        if (num_init_instructions <= 0) return;
        
       // std::cout << "Generating " << num_init_instructions << " additional initialization instructions..." << std::endl;

        for (int i = 0; i < num_init_instructions; i++)
        {
            int rd_num;
            do {
                rd_num = random_reg_num(false);
                // Never reinitialize x31
            } while (std::find(initialized_regs.begin(), initialized_regs.end(), rd_num) != initialized_regs.end() || rd_num == 31);
            
            int imm_val = random_imm12_val();
            std::string rd = std::bitset<5>(rd_num).to_string();
            std::string rs1 = std::bitset<5>(0).to_string(); // Use x0 as source
            std::string imm = std::bitset<12>(imm_val & 0xFFF).to_string();

            std::string binary = imm + rs1 + "000" + rd + "0010011";
            std::string assembly = "addi x" + std::to_string(rd_num) + ", x0, " + std::to_string(imm_val);
            std::string instruction_line = "Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly + " | Binary: " + binary;

            assembly_lines.push_back(assembly);
            binary_lines.push_back(binary);
            instruction_lines.push_back(instruction_line);
            initialized_regs.push_back(rd_num);
            
            std::cout << "  " << instruction_lines.back() << std::endl;
        }
    }

    std::string generate_r_type()
    {
        int rd_num = random_reg_num(false);
        int rs1_num, rs2_num;
        
        // Prefer initialized registers, but allow uninitialized ones
        if (!initialized_regs.empty() && op_dist(rng) % 100 < 80) {
            rs1_num = initialized_regs[op_dist(rng) % initialized_regs.size()];
            rs2_num = initialized_regs[op_dist(rng) % initialized_regs.size()];
        } else {
            rs1_num = random_reg_num();
            rs2_num = random_reg_num();
        }
        
        // Never use x31 as destination in R-type (to preserve its value)
        while (rd_num == 31) {
            rd_num = random_reg_num(false);
        }
        
        std::string rd = std::bitset<5>(rd_num).to_string();
        std::string rs1 = std::bitset<5>(rs1_num).to_string();
        std::string rs2 = std::bitset<5>(rs2_num).to_string();

        std::vector<std::string> operations = {"ADD", "SUB", "AND", "OR", "XOR", "SLL", "SLT", "SLTU"};
        std::string operation = operations[op_dist(rng) % operations.size()];

        std::string func3;
        std::string func7 = "0000000";

        if (operation == "ADD")
        {
            func3 = "000";
        }
        else if (operation == "SUB")
        {
            func3 = "000";
            func7 = "0100000";
        }
        else if (operation == "AND")
        {
            func3 = "111";
        }
        else if (operation == "OR")
        {
            func3 = "110";
        }
        else if (operation == "XOR")
        {
            func3 = "100";
        }
        else if (operation == "SLL")
        {
            func3 = "001";
        }
        else if (operation == "SLT")
        {
            func3 = "010";
        }
        else if (operation == "SLTU")
        {
            func3 = "011";
        }

        std::string binary = func7 + rs2 + rs1 + func3 + rd + "0110011";
        std::string assembly = to_lower(operation) + " x" + std::to_string(rd_num) + ", x" + std::to_string(rs1_num) + ", x" + std::to_string(rs2_num);
        std::string instruction_line = "Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly + " | Binary: " + binary;

        assembly_lines.push_back(assembly);
        binary_lines.push_back(binary);
        instruction_lines.push_back(instruction_line);
        initialized_regs.push_back(rd_num);

        return binary;
    }

    std::string generate_i_type()
    {
        int rd_num = random_reg_num(false);
        int rs1_num;
        
        // Prefer initialized registers
        if (!initialized_regs.empty() && op_dist(rng) % 100 < 80) {
            rs1_num = initialized_regs[op_dist(rng) % initialized_regs.size()];
        } else {
            rs1_num = random_reg_num();
        }
        
        // Never use x31 as destination in I-type (to preserve its value)
        while (rd_num == 31) {
            rd_num = random_reg_num(false);
        }
        
        int imm_val = random_imm12_val();
        std::string rd = std::bitset<5>(rd_num).to_string();
        std::string rs1 = std::bitset<5>(rs1_num).to_string();
        std::string imm = std::bitset<12>(imm_val & 0xFFF).to_string();

        std::vector<std::string> operations = {"ADDI", "ANDI", "ORI", "XORI"};
        std::string operation = operations[op_dist(rng) % operations.size()];

        std::string func3;
        if (operation == "ADDI")
        {
            func3 = "000";
        }
        else if (operation == "ANDI")
        {
            func3 = "111";
        }
        else if (operation == "ORI")
        {
            func3 = "110";
        }
        else if (operation == "XORI")
        {
            func3 = "100";
        }

        std::string binary = imm + rs1 + func3 + rd + "0010011";
        std::string assembly = to_lower(operation) + " x" + std::to_string(rd_num) + ", x" + std::to_string(rs1_num) + ", " + std::to_string(imm_val);
        std::string instruction_line = "Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly + " | Binary: " + binary;

        assembly_lines.push_back(assembly);
        binary_lines.push_back(binary);
        instruction_lines.push_back(instruction_line);
        initialized_regs.push_back(rd_num);

        return binary;
    }
    
std::string generate_jal()
{
    int rd_num = random_reg_num(false);
    
    std::uniform_int_distribution<int> jal_imm_dist(0, 0x7FFFF); // 19-bit immediate range
    int imm_val = jal_imm_dist(rng) & ~1; // Ensure even offset
    
    std::string rd = std::bitset<5>(rd_num).to_string();
    
    // JAL format: imm[20] | imm[10:1] | imm[11] | imm[19:12] | rd | opcode
    // The immediate is encoded in this specific scrambled order
    
    // Extract bits directly from the original immediate value
    uint32_t raw_imm = imm_val;
    
    // Extract and arrange bits in JAL format:
    std::string imm_20 = std::bitset<1>((raw_imm >> 20) & 0x1).to_string();        // bit 20
    std::string imm_10_1 = std::bitset<10>((raw_imm >> 1) & 0x3FF).to_string();    // bits 10:1  
    std::string imm_11 = std::bitset<1>((raw_imm >> 11) & 0x1).to_string();        // bit 11
    std::string imm_19_12 = std::bitset<8>((raw_imm >> 12) & 0xFF).to_string();    // bits 19:12
    
    std::string binary = imm_20 + imm_10_1 + imm_11 + imm_19_12 + rd + "1101111";
    
    // Verify the binary length and opcode
    if (binary.length() != 32) {
        std::cerr << "ERROR: JAL binary length incorrect: " << binary.length() << std::endl;
    }
    if (binary.substr(25, 7) != "1101111") {
        std::cerr << "ERROR: JAL opcode incorrect: " << binary.substr(25, 7) << std::endl;
    }
    
    std::string assembly = "jal x" + std::to_string(rd_num) + ", " + std::to_string(imm_val);
    std::string instruction_line = "Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly + " | Binary: " + binary;

    assembly_lines.push_back(assembly);
    binary_lines.push_back(binary);
    instruction_lines.push_back(instruction_line);
    initialized_regs.push_back(rd_num);

    return binary;
}

std::string generate_jalr()
{
    int rd_num = random_reg_num(false);
    int rs1_num;

    // Prefer initialized registers
    if (!initialized_regs.empty() && op_dist(rng) % 100 < 80) {
        rs1_num = initialized_regs[op_dist(rng) % initialized_regs.size()];
    } else {
        rs1_num = random_reg_num();
    }

    // imm = 0 for JALR
    int imm = 0;
    std::string imm_bin = std::bitset<12>(imm & 0xFFF).to_string();

    std::string rd  = std::bitset<5>(rd_num).to_string();
    std::string rs1 = std::bitset<5>(rs1_num).to_string();

    // JALR encoding:
    // imm[11:0] | rs1 | funct3 | rd | opcode
    // funct3 = 000
    // opcode = 1100111
    std::string binary = imm_bin + rs1 + "000" + rd + "1100111";

    // Correct assembly syntax: jalr rd, imm(rs1)
    std::string assembly = "jalr x" + std::to_string(rd_num) + ", " +
                           std::to_string(imm) + "(x" + std::to_string(rs1_num) + ")";

    std::string instruction_line =
        "Instruction " + std::to_string(instruction_lines.size()) + ": " +
        assembly + " | Binary: " + binary;

    assembly_lines.push_back(assembly);
    binary_lines.push_back(binary);
    instruction_lines.push_back(instruction_line);
    initialized_regs.push_back(rd_num);

    return binary;
}

std::string generate_lui()
{
    int rd_num = random_reg_num(false);
    
    std::uniform_int_distribution<int> lui_imm_dist(0, 0xFFFF);
    int imm_val = lui_imm_dist(rng); // 16-bit immediate value
    
    std::string rd = std::bitset<5>(rd_num).to_string();
    std::string imm = std::bitset<20>(imm_val).to_string(); // 20-bit immediate

    // LUI format: imm[31:12] | rd | 0110111
    std::string binary = imm + rd + "0110111";
    std::string assembly = "lui x" + std::to_string(rd_num) + ", " + std::to_string(imm_val);
    std::string instruction_line = "Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly + " | Binary: " + binary;

    assembly_lines.push_back(assembly);
    binary_lines.push_back(binary);
    instruction_lines.push_back(instruction_line);
    initialized_regs.push_back(rd_num);

    return binary;
}
std::string generate_auipc()
{
    int rd_num = random_reg_num(false);
    
    std::uniform_int_distribution<int> auipc_imm_dist(0, 0xFFFF);
    int imm_val = auipc_imm_dist(rng); // 16-bit immediate value
    
    std::string rd = std::bitset<5>(rd_num).to_string();
    std::string imm = std::bitset<20>(imm_val).to_string(); // 20-bit immediate

    // AUIPC format: imm[31:12] | rd | 0010111
    std::string binary = imm + rd + "0010111";
    std::string assembly = "auipc x" + std::to_string(rd_num) + ", " + std::to_string(imm_val);
    std::string instruction_line = "Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly + " | Binary: " + binary;

    assembly_lines.push_back(assembly);
    binary_lines.push_back(binary);
    instruction_lines.push_back(instruction_line);
    initialized_regs.push_back(rd_num);

    return binary;
}
std::string generate_ecall()
{
    // ECALL: 00000000000000000000000001110011
    std::string binary = "00000000000000000000000001110011";
    std::string assembly = "ecall";
    std::string instruction_line = "Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly + " | Binary: " + binary;

    assembly_lines.push_back(assembly);
    binary_lines.push_back(binary);
    instruction_lines.push_back(instruction_line);

    return binary;
}

std::string generate_ebreak()
{
    // EBREAK: 00000000000100000000000001110011
    std::string binary = "00000000000100000000000001110011";
    std::string assembly = "ebreak";
    std::string instruction_line = "Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly + " | Binary: " + binary;

    assembly_lines.push_back(assembly);
    binary_lines.push_back(binary);
    instruction_lines.push_back(instruction_line);

    return binary;
}

std::string generate_fence()
{
    // FENCE: pred=1111, succ=1111, fm=0, rd=0, rs1=0, 000, rd=0, 0001111
    // Format: 0000 | 1111 | 0000 | 1111 | 00000 | 000 | 00000 | 0001111
    std::string binary = "00001111000011110000000000001111";
    std::string assembly = "fence";
    std::string instruction_line = "Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly + " | Binary: " + binary;

    assembly_lines.push_back(assembly);
    binary_lines.push_back(binary);
    instruction_lines.push_back(instruction_line);

    return binary;
}
    std::string generate_load()
    {
        int rd_num = random_reg_num(false);
        // Always use x31 (initialized to 128) as base register for memory operations
        int rs1_num = 31;
        int imm_val = 0; // Offset 0 from base address 128
        std::string rd = std::bitset<5>(rd_num).to_string();
        std::string rs1 = std::bitset<5>(rs1_num).to_string();
        std::string imm = std::bitset<12>(imm_val & 0xFFF).to_string();

        std::vector<std::string> load_types = {"LB", "LH", "LW", "LBU", "LHU"};
        std::string load_type = load_types[op_dist(rng) % load_types.size()];

        std::string func3;
        if (load_type == "LB")
            func3 = "000";
        else if (load_type == "LH")
            func3 = "001";
        else if (load_type == "LW")
            func3 = "010";
        else if (load_type == "LBU")
            func3 = "100";
        else if (load_type == "LHU")
            func3 = "101";

        std::string binary = imm + rs1 + func3 + rd + "0000011";
        std::string assembly = to_lower(load_type) + " x" + std::to_string(rd_num) + ", " + std::to_string(imm_val) + "(x" + std::to_string(rs1_num) + ")";
        std::string instruction_line = "Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly + " | Binary: " + binary;

        assembly_lines.push_back(assembly);
        binary_lines.push_back(binary);
        instruction_lines.push_back(instruction_line);
        initialized_regs.push_back(rd_num);

        return binary;
    }

 std::string generate_store()
{
    // Always use x31 (initialized to 128) as base register for memory operations
    int rs1_num = 31;
    int rs2_num;
    
    // Prefer initialized registers for storing
    if (!initialized_regs.empty() && op_dist(rng) % 100 < 80) {
        rs2_num = initialized_regs[op_dist(rng) % initialized_regs.size()];
    } else {
        rs2_num = random_reg_num();
    }
    
    int imm_val = 0; // Offset 0 from base address 128
    std::string rs1 = std::bitset<5>(rs1_num).to_string();
    std::string rs2 = std::bitset<5>(rs2_num).to_string();
    std::string imm = std::bitset<12>(imm_val & 0xFFF).to_string();

    std::vector<std::string> store_types = {"SB", "SH", "SW"};
    std::string store_type = store_types[op_dist(rng) % store_types.size()];

    std::string func3;
    if (store_type == "SB")
        func3 = "000";
    else if (store_type == "SH")
        func3 = "001";
    else if (store_type == "SW")
        func3 = "010";

    // Correct store immediate encoding
    std::string imm_11_5 = imm.substr(0, 7);  // bits 11:5
    std::string imm_4_0 = imm.substr(7, 5);   // bits 4:0

    // Store format: imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode
    std::string binary = imm_11_5 + rs2 + rs1 + func3 + imm_4_0 + "0100011";
    std::string assembly = to_lower(store_type) + " x" + std::to_string(rs2_num) + ", " + std::to_string(imm_val) + "(x" + std::to_string(rs1_num) + ")";
    std::string instruction_line = "Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly + " | Binary: " + binary;

    assembly_lines.push_back(assembly);
    binary_lines.push_back(binary);
    instruction_lines.push_back(instruction_line);

    return binary;
}
   std::string generate_branch()
{
    int rs1_num, rs2_num;
    
    // Use initialized registers for branches (more realistic)
    if (initialized_regs.size() >= 2) {
        rs1_num = initialized_regs[op_dist(rng) % initialized_regs.size()];
        do {
            rs2_num = initialized_regs[op_dist(rng) % initialized_regs.size()];
        } while (rs2_num == rs1_num && initialized_regs.size() > 1);
    } else {
        rs1_num = random_reg_num();
        rs2_num = random_reg_num();
    }

    std::uniform_int_distribution<int> branch_imm_dist(-100, 100);
    int imm_val = branch_imm_dist(rng) & ~1;
    std::string rs1 = std::bitset<5>(rs1_num).to_string();
    std::string rs2 = std::bitset<5>(rs2_num).to_string();
    
    // Correct branch immediate encoding
    std::bitset<13> imm_bits(imm_val & 0x1FFF);
    std::string imm = imm_bits.to_string();

    std::vector<std::string> branch_types = {"BEQ", "BNE", "BLT", "BGE", "BLTU", "BGEU"};
    std::string branch_type = branch_types[op_dist(rng) % branch_types.size()];

    std::string func3;
    if (branch_type == "BEQ")
        func3 = "000";
    else if (branch_type == "BNE")
        func3 = "001";
    else if (branch_type == "BLT")
        func3 = "100";
    else if (branch_type == "BGE")
        func3 = "101";
    else if (branch_type == "BLTU")
        func3 = "110";
    else if (branch_type == "BGEU")
        func3 = "111";

    // Correct branch immediate field ordering
    std::string imm_12 = imm.substr(0, 1);    // bit 12
    std::string imm_11 = imm.substr(1, 1);    // bit 11  
    std::string imm_10_5 = imm.substr(2, 6);  // bits 10:5
    std::string imm_4_1 = imm.substr(8, 4);   // bits 4:1

    // Branch format: imm[12] | imm[10:5] | rs2 | rs1 | funct3 | imm[4:1] | imm[11] | opcode
    std::string binary = imm_12 + imm_10_5 + rs2 + rs1 + func3 + imm_4_1 + imm_11 + "1100011";
    std::string assembly = to_lower(branch_type) + " x" + std::to_string(rs1_num) + ", x" + std::to_string(rs2_num) + ", " + std::to_string(imm_val);
    std::string instruction_line = "Instruction " + std::to_string(instruction_lines.size()) + ": " + assembly + " | Binary: " + binary;

    assembly_lines.push_back(assembly);
    binary_lines.push_back(binary);
    instruction_lines.push_back(instruction_line);

    return binary;
}
std::string generate_instruction()
{
    int choice = op_dist(rng) % 100;

    if (choice < 20)
        return generate_r_type();
    else if (choice < 40)
        return generate_i_type();
    else if (choice < 48)
        return generate_load();
    else if (choice < 56)
        return generate_store();
    else if (choice < 64)
        return generate_branch();
    else if (choice < 68)
        return generate_jal();
    else if (choice < 72)
        return generate_jalr();
    else if (choice < 76)
        return generate_lui();
    else if (choice < 80)
        return generate_auipc();
    else if (choice < 82)
        return generate_ecall();
    else if (choice < 84)
        return generate_ebreak();
    else if (choice < 86)
        return generate_fence();
    else
        return generate_r_type(); // Fallback to R-type
}
std::string bin_to_hex(const std::string &bin)
    {
        if (bin.length() != 32)
        {
            return "32'h00000000";
        }

        std::bitset<32> bits(bin);
        unsigned long value = bits.to_ulong();
        std::stringstream ss;
        ss << "32'h" << std::hex << std::uppercase << std::setw(8) << std::setfill('0') << value;
        return ss.str();
    }

    std::vector<std::string> split_to_bytes_little_endian(const std::string &binary)
    {
        std::vector<std::string> bytes;
        if (binary.length() != 32)
            return bytes;

        // Little-endian: store bytes from least significant to most significant
        for (int i = 3; i >= 0; i--)
        {
            std::string byte_str = binary.substr(i * 8, 8);
            std::bitset<8> byte_bits(byte_str);
            std::stringstream ss;
            ss << "8'h" << std::hex << std::uppercase << std::setw(2) << std::setfill('0') << byte_bits.to_ulong();
            bytes.push_back(ss.str());
        }
        return bytes;
    }

    void generate_hex_file(const std::string &folder_path, const std::string &base_filename)
    {
        std::string hex_filename = folder_path + "/" + base_filename + "_hex.txt";
        std::ofstream hex_file(hex_filename);

        if (!hex_file.is_open())
        {
            std::cerr << "ERROR: Cannot create hex file!" << std::endl;
            return;
        }

        hex_file << "// RISC-V Instruction Memory Hex Dump" << std::endl;
        hex_file << "// " << binary_lines.size() << " instructions" << std::endl;
        hex_file << "// x31 initialized to 128 for memory operations" << std::endl;
        hex_file << std::endl;

        for (size_t i = 0; i < binary_lines.size(); i++)
        {
            std::bitset<32> bits(binary_lines[i]);
            unsigned long value = bits.to_ulong();
            hex_file << "0x" << std::hex << std::uppercase << std::setw(8) << std::setfill('0') << value;
            hex_file << " // " << assembly_lines[i] << std::endl;
        }

        hex_file.close();
        std::cout << "Created: " << hex_filename << std::endl;
    }

    void generate_test_program(int num_instructions, const std::string &base_filename)
    {
        assembly_lines.clear();
        binary_lines.clear();
        instruction_lines.clear();
        initialized_regs.clear();
        initialization_done = false;

        if (num_instructions < 0)
            num_instructions = 0;
        if (num_instructions > 32)
            num_instructions = 32;

        std::cout << "Generating " << num_instructions << " instructions (0-32 limit applied)..." << std::endl;

        // Create folder for test files
        std::string folder_name = base_filename + "_test";
        if (!create_test_directory(folder_name)) {
            std::cerr << "ERROR: Cannot create test directory. Files will be saved in current directory." << std::endl;
            folder_name = "."; // Use current directory as fallback
        }

        // Always generate fixed initialization first (2 instructions)
        std::cout << "------------------------------------------" << std::endl;
        generate_fixed_initialization();

        // Calculate remaining instructions for additional initialization and main program
        int remaining_instructions = num_instructions - 2;
        if (remaining_instructions < 0) {
            std::cout << "Warning: Only fixed initialization instructions generated." << std::endl;
            remaining_instructions = 0;
        }

        // Calculate how many instructions to use for additional initialization (20-30% of remaining)
        int additional_init_instructions = std::max(0, remaining_instructions / 5);
        int main_instructions = remaining_instructions - additional_init_instructions;

        // Generate additional initialization instructions
        if (additional_init_instructions > 0) {
         //   std::cout << "------------------------------------------" << std::endl;
            generate_additional_initialization(additional_init_instructions);
        }

        // Generate main program instructions
        if (main_instructions > 0) {
        //    std::cout << "------------------------------------------" << std::endl;
         //   std::cout << "Generating " << main_instructions << " main instructions..." << std::endl;

            for (int i = 0; i < main_instructions; i++)
            {
                std::string binary = generate_instruction();
                std::cout << "  " << instruction_lines.back() << std::endl;
            }
        }

        // Generate instruction details file
        std::string inst_filename = folder_name + "/" + base_filename + "_instructions.txt";
        std::ofstream inst_file(inst_filename);

        if (!inst_file.is_open())
        {
            std::cerr << "ERROR: Cannot create instructions file!" << std::endl;
            return;
        }

        inst_file << "==========================================" << std::endl;
        inst_file << "    RISC-V INSTRUCTION DETAILS" << std::endl;
        inst_file << "==========================================" << std::endl;
        inst_file << "Total Instructions: " << num_instructions << std::endl;
        inst_file << "Fixed Initialization: 2 instructions" << std::endl;
        inst_file << "Additional Initialization: " << additional_init_instructions << " instructions" << std::endl;
        inst_file << "Main Instructions: " << num_instructions + additional_init_instructions + main_instructions << " instructions" << std::endl;
        inst_file << "Memory Base Address: 0 to 31 for instructions" << std::endl;
        inst_file << "Data Memory Base: 128 (x31 initialized to 128)" << std::endl;
        inst_file << "Initialized Registers: ";
        for (size_t i = 0; i < initialized_regs.size(); i++) {
            inst_file << "x" << initialized_regs[i];
            if (i < initialized_regs.size() - 1) inst_file << ", ";
        }
        inst_file << std::endl;
        inst_file << "==========================================" << std::endl;
        inst_file << std::endl;

        for (const auto &line : instruction_lines)
        {
            inst_file << line << std::endl;
        }

        inst_file.close();
        std::cout << "Created: " << inst_filename << std::endl;

        // Generate assembly file
        std::string asm_filename = folder_name + "/" + base_filename + "_asm.txt";
        std::ofstream asm_file(asm_filename);

        if (!asm_file.is_open())
        {
            std::cerr << "ERROR: Cannot create assembly file!" << std::endl;
            return;
        }

        asm_file << "// RISC-V Assembly Test Program" << std::endl;
        asm_file << "// " << num_instructions << " instructions" << std::endl;
        asm_file << "// Fixed Initialization: 2 instructions" << std::endl;
        asm_file << "// Additional Initialization: " << additional_init_instructions << " instructions" << std::endl;
        asm_file << "// Main: " << main_instructions << " instructions" << std::endl;
        asm_file << "// Memory base address: 0 to 31" << std::endl;
        asm_file << "// Data memory base: 128 (x31)" << std::endl;
        asm_file << std::endl;

        for (int i = 0; i < num_instructions; i++)
        {
            asm_file << assembly_lines[i] << std::endl;
        }

        asm_file.close();
        std::cout << "Created: " << asm_filename << std::endl;

        // Generate binary file
        std::string bin_filename = folder_name + "/" + base_filename + "_binary.v";
        std::ofstream bin_file(bin_filename);

        if (!bin_file.is_open())
        {
            std::cerr << "ERROR: Cannot create binary file!" << std::endl;
            return;
        }

        int total_memory_size = num_instructions * 4 - 1;

        bin_file << "// RISC-V Binary Test Program" << std::endl;
        bin_file << "// " << num_instructions << " instructions in 8-bit memory" << std::endl;
        bin_file << "// Memory base address: 0 to " << (num_instructions * 4 - 1) << std::endl;
        bin_file << "// x31 initialized to 128 for memory operations" << std::endl;
        bin_file << "// Little-endian byte ordering" << std::endl;
        bin_file << "module TestMemory;" << std::endl;
        bin_file << "    reg [7:0] mem [0:" << total_memory_size << "];" << std::endl;
        bin_file << "    initial begin" << std::endl;

        // First two fixed instructions
        bin_file << std::endl << "        // Fixed Initialization Instructions" << std::endl;
        
        // Instruction 0: ADDI x0, x0, 0 (NOP) - 0x00000013
        bin_file << "        // ADDI x0, x0, 0" << std::endl;
        bin_file << "        mem[0] = 8'h13; // bits [7:0]" << std::endl;
        bin_file << "        mem[1] = 8'h00; // bits [15:8]" << std::endl;
        bin_file << "        mem[2] = 8'h00; // bits [23:16]" << std::endl;
        bin_file << "        mem[3] = 8'h00; // bits [31:24]" << std::endl;
        
        // Instruction 1: ADDI x31, x0, 128 - 0x08000F93
        bin_file << std::endl << "        // ADDI x31, x0, 128" << std::endl;
        bin_file << "        mem[4] = 8'h93; // bits [7:0]" << std::endl;
        bin_file << "        mem[5] = 8'h0F; // bits [15:8]" << std::endl;
        bin_file << "        mem[6] = 8'h00; // bits [23:16]" << std::endl;
        bin_file << "        mem[7] = 8'h08; // bits [31:24]" << std::endl;

        // Remaining instructions (starting from instruction 2)
        for (int i = 2; i < num_instructions; i++)
        {
            std::vector<std::string> bytes = split_to_bytes_little_endian(binary_lines[i]);
            int base_addr = i * 4;

            bin_file << std::endl
                     << "        // " << assembly_lines[i] << std::endl;
            bin_file << "        // " << bin_to_hex(binary_lines[i]) << std::endl;

            for (int j = 0; j < 4; j++)
            {
                bin_file << "        mem[" << (base_addr + j) << "] = " << bytes[j] << ";" << std::endl;
            }
        }

        bin_file << "    end" << std::endl;
        bin_file << "endmodule" << std::endl;
        bin_file.close();

        std::cout << "Created: " << bin_filename << std::endl;

        generate_hex_file(folder_name, base_filename);

        std::cout << "------------------------------------------" << std::endl;
        std::cout << "SUCCESS! Generated " << num_instructions << " instructions." << std::endl;
       // std::cout << "Fixed Initialization: 2 instructions" << std::endl;
        //std::cout << "Additional Initialization: " << additional_init_instructions << " instructions" << std::endl;
        //std::cout << "Main program: " << main_instructions << " instructions" << std::endl;
        std::cout << "Memory usage: " << (num_instructions * 4) << " bytes used" << std::endl;
        std::cout << "Memory allocated: " << (total_memory_size + 1) << " bytes total (0-" << total_memory_size << ")" << std::endl;
        std::cout << "x31 initialized to 128 and preserved throughout" << std::endl;
        std::cout << "Little-endian byte ordering used" << std::endl;
        std::cout << "All files saved in folder: " << folder_name << std::endl;
        
        // List all generated files
        std::cout << "Generated files:" << std::endl;
        std::cout << "  - " << base_filename << "_instructions.txt" << std::endl;
        std::cout << "  - " << base_filename << "_asm.txt" << std::endl;
        std::cout << "  - " << base_filename << "_binary.v" << std::endl;
        std::cout << "  - " << base_filename << "_hex.txt" << std::endl;
    }
};

int main()
{
    std::cout << "==========================================" << std::endl;
    std::cout << "    RISC-V TEST PROGRAM GENERATOR" << std::endl;
    std::cout << "==========================================" << std::endl;
    std::cout << "Features:" << std::endl;
    std::cout << "- Fixed initialization: ADDI x0,x0,0 and ADDI x31,x0,128" << std::endl;
    std::cout << "- x31 preserved at 128 for memory operations" << std::endl;
    std::cout << "- All instruction types: R, I, S, B, U, J formats" << std::endl;
    std::cout << "- Includes: ALU, Load/Store, Branch, Jump, System instructions" << std::endl;
    std::cout << "- Instruction limit: 0-31" << std::endl;
    std::cout << "- Organized folder structure" << std::endl;
    std::cout << "- Little-endian byte ordering" << std::endl;
    std::cout << "==========================================" << std::endl;
    std::cout << std::endl;

    RISC_V_TestGenerator generator;

    std::string filename;
    std::cout << "Enter output filename (without extension): ";
    std::cin >> filename;

    int num_instructions;
    std::cout << "Enter number of instructions to generate (2-31): ";
    std::cin >> num_instructions;

    if (num_instructions < 2)
    {
        std::cout << "Minimum 2 instructions required! Using 2 instructions." << std::endl;
        num_instructions = 2;
    }
    if (num_instructions > 31)
    {
        std::cout << "Number too large! Using maximum 31 instructions." << std::endl;
        num_instructions = 31;
    }

    std::cout << std::endl;
    std::cout << "Starting generation..." << std::endl;
    std::cout << "------------------------------------------" << std::endl;

    generator.generate_test_program(num_instructions, filename);

    std::cout << "------------------------------------------" << std::endl;
    std::cout << "Generation complete!" << std::endl;
    std::cout << "Press Enter to exit...";
    std::cin.ignore();
    std::cin.get();

    return 0;
}