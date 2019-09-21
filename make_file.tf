
data "template_file" "test" {
  template = "${file("files/test.txt.tpl")}"

  vars = {
    test_string = "this is a file"
  }
}


data "template_file" "test2" {
  template = "${file("files/test2.txt.tpl")}"

  vars = {
    test_file  = "${data.template_file.test.rendered}"
    test_file3 = "${file("files/test3.txt")}"
  }
}


resource "null_resource" "write_file" {
  provisioner "local-exec" {
    command = <<EOT
    echo "${data.template_file.test2.rendered}" > "${var.output_filename}"
    EOT
  }
}

variable "output_filename" {
  description = "Path/name of output file"
  default     = "output.txt"
}

output "test_file" {
  value = "${data.template_file.test2.rendered}"
}
