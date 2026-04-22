# Portfólio Static Website com Infraestrutura AWS

Este projeto é um portfólio pessoal estático, hospedado em uma instância EC2 na AWS, com infraestrutura gerenciada por Terraform e provisionamento automatizado via Ansible.

## Estrutura do Projeto

- `pages/` — Contém a página HTML estática do portfólio.
- `infra_aws/` — Infraestrutura como código (IaC) para AWS usando Terraform:
  - `main.tf` — Criação de VPC, Subnet, Security Group, Internet Gateway, Route Table e EC2.
  - `playbook-nginx.yml` — Playbook Ansible para instalar e iniciar o Nginx na EC2.
  - `hosts` — Inventário Ansible para conectar na EC2.
- `.gitignore` — Arquivos e pastas ignorados no versionamento, incluindo arquivos sensíveis do Terraform.

## Como funciona

1. **Infraestrutura AWS (Terraform):**
	- Cria uma VPC, subnet pública, security group liberando HTTP, HTTPS e SSH.
	- Cria uma instância EC2 (t3.micro, Free Tier elegível) com IP público.
	- Não utiliza Elastic IP para evitar cobranças extras.

2. **Provisionamento (Ansible):**
	- Instala e inicia o Nginx na EC2 automaticamente.
	- O acesso SSH é feito via key pair configurada na AWS.

## Passos para uso

1. **Configurar variáveis sensíveis:**
	- Crie uma key pair na AWS e baixe o arquivo `.pem`.
	- Ajuste o parâmetro `key_name` no `main.tf` se necessário.

2. **Provisionar infraestrutura:**
	```sh
	cd infra_aws
	terraform init
	terraform apply
	```

3. **Provisionar a EC2 com Ansible:**
	- Edite o arquivo `hosts` e coloque o IP público da EC2.
	- Execute:
	```sh
	ansible-playbook -i hosts playbook-nginx.yml
	```

4. **Acessar o portfólio:**
	- Após o playbook, acesse o IP público da EC2 no navegador (porta 80).

## Observações
- Não faça commit de arquivos `.pem` ou arquivos de estado do Terraform.
- O projeto está pronto para deploy rápido e seguro na AWS.

---

Sinta-se à vontade para customizar a página HTML e a infraestrutura conforme sua necessidade!
