# encoding: UTF-8
if AdminModule.count == 0
	AdminModule.create(name:"Пользователи",action:"users",parent_id:0,:ico_cls=>"icon-group")
	AdminModule.create(name:"Фото",action:"photos",parent_id:0,:ico_cls=>"icon-picture")
	AdminModule.create(name:"Активность",action:"activity",parent_id:0,:ico_cls=>"sidebar-forms")
	AdminModule.create(name:"Контент",action:"articles",parent_id:0,:ico_cls=>"sidebar-widgets")
	#AdminModule.create(name:"Настройки",action:"settings",parent_id:0,:ico_cls=>"sidebar-gear")
	#AdminModule.create(name:"Шаблони Email",action:"emails",parent_id:0,:ico_cls=>"sidebar-forms")
	#AdminModule.create(name:"Довідник",action:"articles",parent_id:0,:ico_cls=>"sidebar-widgets")
end

if User.count == 0
	user = User.create(username:"Админ",email:"admin@admin.net",password:"admin")
	admin_role = Role.create(role_type:"admin",name:"Administrator")
	admin_role_2 = Role.create(role_type:"full_admin",name:"Full Admin privileges")
	user.roles << admin_role
	user.roles << admin_role_2
	user.save
	admin_role_2.admin_modules << AdminModule.all
	admin_role_2.save
end