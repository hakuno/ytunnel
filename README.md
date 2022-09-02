# ytunnel

Split tunnel for your VPN easily. Do it as a service in your Linux box (tested on Ubuntu).

Ps. turn on your VPN connection before.

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

Lembrando-se que é necessário ter o serviço de VPN em execução para usufruir das rotas.

## Misc

### Para instalar usando `make`

A variável `DEPENDS_ON` possui os serviços que devem ser aguardados. Porém, a mágica ainda acontece em função de um `sleep` para aguardar a route table desejada para alteração.

```
make DEPENDS_ON="network.target" install
```

### Para acompanhar os logs

```
sudo journalctl -u ytunnel
```

### Para acompanhar o serviço

```
sudo systemctl cat ytunnel
```