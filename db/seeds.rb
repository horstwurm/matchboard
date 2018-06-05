# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

path=File.join(Rails.root, "/app/assets/images/")

mcategories = Mcategory.create({ctype:"sportstaette", name:"Verein"})
mcategories = Mcategory.create({ctype:"sportstaette", name:"Sportstaette"})

mcategories = Mcategory.create({ctype:"gruppen", name:"Organisationseinheit"})

mcategories = Mcategory.create({ctype:"gruppen", name:"Gruppe (privat)"})
mcategories = Mcategory.create({ctype:"gruppen", name:"Mannschaft"})

mcategories = Mcategory.create({ctype:"plaetze", name:"indoor"})
mcategories = Mcategory.create({ctype:"plaetze", name:"outdoor"})

mcategories = Mcategory.create({ctype:"matchtype", name:"Einzel"})
mcategories = Mcategory.create({ctype:"matchtype", name:"Doppel"})

#create some users...
#users = User.create({org: "OE4711", costinfo: "KST0815", rate:150, calendar:true, time_from:8, time_to:20, dateofbirth:"09.05.1963", anonymous:false, status:"OK", active:true, email:"horst.wurm@bluewin.ch", password:"password", name:"Horst", lastname:"Wurm", address1:"Hörnliblick 11", address2:"Zezikon", address3:"Thurgau", superuser:true, webmaster:true, avatar:File.open(path+'horst.gif', 'rb')})
users = User.create({dateofbirth:"09.05.1963", anonymous:false, status:"OK", active:true, email:"horst.wurm@bluewin.ch", password:"password", name:"Horst", lastname:"Wurm", address1:"Hörnliblick 11", address2:"Zezikon", address3:"Thurgau", superuser:true, webmaster:true})
users = User.create({dateofbirth:"09.05.1963", anonymous:false, status:"OK", active:true, email:"hans.wurst@bluewin.ch", password:"password", name:"Hans", lastname:"Wurst", address1:"Im Roos", address2:"Weinfelden", address3:"Thurgau", superuser:true, webmaster:true})
users = User.create({dateofbirth:"09.05.1963", anonymous:false, status:"OK", active:true, email:"peter.muster@bluewin.ch", password:"password", name:"Hans", lastname:"Muster", address1:"Hauptstrasse", address2:"Affeltrangen", address3:"Thurgau", superuser:true, webmaster:true})

#create some favorits
usanz = User.all.count-1
random = Random.new(Time.new.to_i)
for i in 0..3
    ura1 = rand(usanz)+1
    ura2 = rand(usanz)+1
    favourits = Favourit.create({user_id: ura1, object_name:"User", object_id: ura2})
end

#create some companies...
companies = Company.create({status:"OK", active:true, user_id:1, name:"Tennisclub 1", mcategory_id:1 ,stichworte: "Fische, Zierfische, Angelbedarf", address1:"Lauligstrasse 8", address2:"Weinfelden", address3:"Thurgau"}) 
companies = Company.create({status:"OK", active:true, user_id:2, name:"Tennisclub 2", mcategory_id:1 ,stichworte: "Hocbau, Tiefbau Müll Abfall Recycling", address1:"Rüteliholzstrasse 4", address2:"Weinfelden", address3:"Thurgau"}) 
companies = Company.create({status:"OK", active:true, user_id:3, name:"Tennisclub 3", mcategory_id:1 ,stichworte: "Eisenwaren Geräte Baumaschinen Werkzeuge", address1:"Grüterholz", address2:"Frauenfeld", address3:"Thurgau"}) 

courts = Mobject.create({status:"OK", active:true, mtype:"plaetze", owner_type:"Company", owner_id:1, name:"Platz 1", mcategory_id:6 ,keywords: "", address1:"Grüterholz", address2:"Frauenfeld", address3:"Thurgau"}) 

games = Game.create({user_id:1, mobject_id:1, mcategory_id:8, player1:"horst.wurm@bluewin.ch", player2:"hans.wurst@bluewin.ch", modus:"TieBreak", }) 
