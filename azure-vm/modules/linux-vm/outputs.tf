
output "key_data" {
    value = azapi_resource_action.ssh_public_key_gen[*].output.publicKey
}

output "key_priv" {
    value = azapi_resource_action.ssh_public_key_gen[*].output.privateKey
}