terraform {
    required_providers {
        local = {
            source = "hashicorp/local"
            version = "2.4.0"
        }
    }
}

resource "local_file" "test_file"{
    filename = "test.txt"
    content = "This is a test fike"
}