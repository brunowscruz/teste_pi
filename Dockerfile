FROM alpine as inicio

# Pega uma chave ssh com argumento de construção
ARG SSH_KEY

# Instancia o usuario diferente de root para executar o container com as permissões específicas desse usuário
RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser
USER appuser

# instala dependencia requeridas para o gitclone
RUN apk update && \
    apk add --update git && \
    apk add --update openssh

RUN mkdir -p /root/.ssh/ && \
    echo "$SSH_KEY" > /root/.ssh/id_rsa && \
    chmod -R 600 /root/.ssh/ && \
    ssh-keyscan -t rsa gitlab.com >> ~/.ssh/known_hosts

# Clona o repositório
RUN git clone git@gitlab.com:pi-eng/sre-exam.git

# Limpa a chave SSH para manter a segurança
RUN rm -rf /root/.ssh/id_rsa

#inicia o container no modo bash
ENTRYPOINT ["/bin/bash", "-l", "-c"]

# inicia uma nova imagem usando o mesmo arquivo
FROM alpine

# Copiando arquivos a partir do container de início (acima)
RUN mkdir files
COPY --from=inicio /files/README.md /files/README.md
