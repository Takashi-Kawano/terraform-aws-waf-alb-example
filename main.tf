# モジュールを利用するファイル

module "web" {
    source = "./module"

    allow_request_ip = "127.0.0.1/32"
}
