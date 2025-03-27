resource local_file "local_file"{
    filename = "local_file.txt"
}

resource local_file "local_file1"{
    filename = "local_file1.txt"
    provider = local_file.custom
}