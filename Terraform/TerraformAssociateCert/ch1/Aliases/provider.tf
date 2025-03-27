provider "local_file" {
    content = "This is from local provider"
}

provider "local_file" {
    alias = "custom"
    content = "This is from custom local provider"
}