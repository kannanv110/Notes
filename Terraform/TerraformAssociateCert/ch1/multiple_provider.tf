resource local_file "local_file" {
    filename = "local-file.txt"
    content = "This is a local file"
}

resource random_pet "random_pet"{
    length = 2
    prefix = "Mrs."
    separator = " "
}

resource random_string "random_password"{
    length = 16
    upper = true
    lower = true
    special = true
    numeric = true
}