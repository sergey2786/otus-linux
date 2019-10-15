##### Домашнее задание 	"Пользователи и группы. Авторизация и аутентификация"
#### Подготовка стенда
	  1. Скачиваем Vagrant файл и запускаем (vagrant up).
#### Проверка 
	  1. Пробовать зайти под пользователем day. Должен пустить только в субботу и воскресенье, так как пользователь в группе admin проверка на принадлежность к группе в файле test_login.sh.
	  2. Проверка  root прав пользователя day (залогиниться под ним перейти в sudo). Должен перейти без запроса пароля 
	  3. Пользователю test не разрешенн совсем вход (правила прописанны в файле time.conf правило выглядит так *;*;test;!Tu).
#### Модули pam прописываем в файле /etc/pam.d/sshd
	 Он должен получится примерно таким:

		#%PAM-1.0
		account  required  pam_time.so 
		account required  pam_exec.so /usr/local/bin/test_login.sh
		auth	   required	pam_sepermit.so
		auth       substack     password-auth
		auth       include      postlogin
		# Used with polkit to reauthorize users in remote sessions
		-auth      optional     pam_reauthorize.so prepare
		account    required     pam_nologin.so
		account    include      password-auth
		password   include      password-auth
		# pam_selinux.so close should be the first session rule
		session    required     pam_selinux.so close
		session    required     pam_loginuid.so
		# pam_selinux.so open should only be followed by sessions to be executed in the user context
		session    required     pam_selinux.so open env_params
		session    required     pam_namespace.so
		session    optional     pam_keyinit.so force revoke
		session    include      password-auth
      	session    include      postlogin
     	-session   optional     pam_reauthorize.so prepare

##### На стенд входим так по адресу 192.168.11.150. Пароль root 1234 у него ограничений нет. Пароль day и test 2019