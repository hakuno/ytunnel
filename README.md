# ytunnel

Split tunnel for your VPN easily. Do it as a service in your Linux box (tested on Ubuntu).

## Setup

Para instalar remotamente, execute em um terminal Linux:

> O seu usuário precisa de permissões `sudo`

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/hakuno/ytunnel/main/install.sh)"
```

Alimente a lista em `/opt/ytunnel/endpoints.dat`. Cada linha representa uma rota a ser aplicada para o túnel VPN. Por exemplo:

```
endereco.restrito.com.br
10.1.1.2
35.0.2.34
```

Agora, você pode gerenciar o serviço:

```
sudo systemctl start ytunnel.service
sudo systemctl enable ytunnel.service
```

## Misc

Para instalar usando `make`

```
make DEPENDS_ON="network.target" install
```