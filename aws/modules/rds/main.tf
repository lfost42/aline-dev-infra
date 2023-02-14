resource "aws_db_instance" "alinedb" {
    name = "alineDB"
    identifier = "alinedb"
    instance_class = "db.t2.medium"
    engine = "mysql"
    engine_version = "10.2.21"
    username = "admin"
    password = "really_good_password"
    port = 3306
    allocated_storage = 20
    skip_final_snapshot = true
}