FROM ubuntu:22.04

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar OpenSSH Server, Sudo y Python (necesario para Ansible)
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Configurar el directorio para el servicio SSH
RUN mkdir /var/run/sshd

# Crear el usuario 'ansible' con contraseña 'ansible'
RUN useradd -rm -d /home/ansible -s /bin/bash -g root -G sudo -u 1000 ansible
RUN echo 'ansible:ansible' | chpasswd

# Permitir que el usuario ansible use sudo sin contraseña
RUN echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Exponer el puerto SSH
EXPOSE 22

# Iniciar el servidor SSH en primer plano
CMD ["/usr/sbin/sshd", "-D"]