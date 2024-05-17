# Systolic_Matrix_Multiply

### Overview
Systolic matrix multiplication is used all over for its ability to proccess large matrices. This is my attempt to try making one :). I have higlighted a few of the main functions and what they do. 

 
### 1. **Control Module**
This module orchestrates the operation of the entire systolic array:
- **Inputs**: `clk` (clock signal), `rst` (reset signal), `enable_row_count` (enables the row counting mechanism).
- **Outputs**: Counters for pixel and slice indices (`pixel_cntr_A`, `slice_cntr_A`, `pixel_cntr_B`, `slice_cntr_B`) and read addresses (`rd_addr_A`, `rd_addr_B` for matrices A and B respectively).
- **Functionality**:
  - **Address Calculation**: Computes the read addresses for the matrices A and B using the pixel and slice counters. The formulae `pixel_cntr_A + slice_cntr_A * M` and `slice_cntr_B + pixel_cntr_B * M` ensure each processing element accesses the correct matrix element.
  - **Counter Modules**: The `control` module uses two instances of the `counter` module to manage `pixel_cntr_A`, `slice_cntr_A`, `pixel_cntr_B`, and `slice_cntr_B`. These counters help navigate through the matrices by counting rows and columns.

### 2. **Counter Module**
Responsible for counting pixels and slices, important for addressing matrix elements in the systolic array:
- **Parameters**: `WIDTH` and `HEIGHT` define the dimensions to be counted.
- **Functionality**:
  - **Counting Logic**: This module increments the pixel counter until it reaches the end of a row/column (determined by `WIDTH`), at which point it resets and increments the slice counter (mod `HEIGHT`). This cyclic behavior ensures every element within the specified dimensions is accessed sequentially.

### 3. **PE (Processing Element) Module**
Each PE performs actual data processing within the systolic array:
- **Inputs**: Operand inputs (`in_a`, `in_b`), initial data (`in_data`), validity of initial data (`in_valid`), and an initialization signal (`init`).
- **Outputs**: Outputs processed data (`out_data`), validity of output data (`out_valid`), and outputs data to the next PE (`out_a`, `out_b`).
- **Functionality**:
  - **Data Processing**: On initialization (`init` is high), it computes the product of `in_a` and `in_b` and stores it in `out_sum`. Otherwise, it adds the product of `in_a` and `in_b` to the previously stored sum (`out_sum`), simulating an accumulation operation which is typical in matrix multiplication.
  - **Data Propagation**: Continuously forwards inputs (`in_a`, `in_b`) to outputs to be used by the next PE in the array.

### 4. **Pipe Module**
Implements pipelining within each PE to manage latency and ensure smooth data flow:
- **Parameter**: `pipes` indicates the depth of the pipeline.
- **Functionality**:
  - **Pipeline Registers**: Uses an array of registers (`regs`) to delay the input signal (`in_p`) by a number of clock cycles specified by `pipes`. This delay is critical in synchronizing operations across PEs, especially in a deep systolic array.

### Integration in a Systolic Array
In the complete systolic array:
- **Matrix Multiplication**: Each PE receives a part of matrices A and B, processes them, and passes results along to neighbors. The control and counter modules manage the systematic flow of data and indexing.
- **Synchronization**: The `pipe` module in each PE helps in managing the delay introduced by each stage in the array, maintaining synchronization across all PEs.
- **Scalability**: Parameters like `N1`, `N2`, and `M` allow the design to be scalable based on the matrix size and the desired array dimensions.

This systolic array design is highly effective for parallel processing tasks like matrix multiplication, which is central to applications such as deep learning and signal processing. Each module's specific responsibilities and interconnections ensure efficient and synchronized processing across the entire array.

