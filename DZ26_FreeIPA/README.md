### Домашнее задание LDAP
    1. Установить FreeIPA;
    2. Написать Ansible playbook для конфигурации клиента;
    3*. Настроить аутентификацию по SSH-ключам;
    4**. Firewall должен быть включен на сервере и на клиенте.
    
#### 1. Установить FreeIPA:
     Ansible playbook вглядить так:
         ---
         - name: Install FreeIPA Server
         hosts: server.test.domain
         vars_files:
         - group_vars/ipaserver/vars.yml
         become: yes
         pre_tasks:
         - file: path=/etc/hosts state=absent
         - file: path=/etc/hosts state=touch
         - yum: 
            name=firewalld 
            state=present
         - systemd: name=firewalld state=started enabled=yes
         - name: upgrade all packages
         yum:
         name: '*'
         state: latest
         roles:
         - role: ipaserver
         state: present
      
         - name: Install FreeIPA clent
         hosts: client.test.domain
         vars_files:
          - group_vars/ipaclient/vars.yml
         become: yes
         pre_tasks: 
         - file: path=/etc/hosts state=absent
         - file: path=/etc/hosts state=touch
         - yum: 
             name=firewalld 
             state=present
         - systemd: name=firewalld state=started enabled=yes
         - name: upgrade all packages
         yum:
          name: '*'
          state: latest
         roles:
          - role: ipaclient
            state: present
