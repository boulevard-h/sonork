import argparse
import pickle

def main():
    # 创建命令行参数解析器
    parser = argparse.ArgumentParser(description="Load a pickle file and display its contents.")
    
    # 添加参数，用于指定文件路径
    parser.add_argument(
        "-f", "--file", 
        type=str, 
        required=True, 
        help="Path to the pickle file to be loaded"
    )
    
    # 解析命令行参数
    args = parser.parse_args()
    
    # 获取文件路径
    file_path = args.file
    
    try:
        # 加载 pickle 文件
        with open(file_path, 'rb') as file:
            data = pickle.load(file)
        
        # 打印加载的数据
        print("Loaded data from pickle file:")
        print(data)
    except FileNotFoundError:
        print(f"Error: File not found at path '{file_path}'. Please provide a valid file path.")
    except pickle.UnpicklingError:
        print(f"Error: Failed to unpickle the file. Ensure the file is a valid pickle file.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    main()