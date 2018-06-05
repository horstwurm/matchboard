module UsersHelper

def qrcodeimg(mobject, size)

  mtype = mobject.class.table_name
  mid = mobject.id
  
  content = "https://mytgcloud.herokuapp.com"+url_for(mobject)

  @qr = Qrcode.where('mobject_type=? and mobject_id=?', mobject.class.table_name, mobject.id).first

  if !@qr
    qr = RQRCode::QRCode.new(content, size: 12, :level => :h)
    qr_img = qr.to_img
    qr_img.resize(200, 200).save("app_qrcode.png")
    @qr = Qrcode.new
    @qr.mobject_type= mtype
    @qr.mobject_id = mid
    @qr.avatar = File.open("app_qrcode.png")
    @qr.save
  end

  hash = Hash.new
  hash = {"qr_text" => content, "qr_code" => image_tag(@qr.avatar(:small)) }
  return hash

end

def small_carousel(company, size)

    html = ""
    html = html +  '<div class="owl-show2">'
    mobjects = company.mobjects
    mobjects.where('mtype!=? and mtype!=?',"kampagnen", "standorte").each do |m|

      #m.mdetails.each do |s|
        #if s.avatar_file_name
          html = html + "<div align=center>"+ (showFirstImage2(:medium, m, m.mdetails)) + "<h4>" + m.mtype + ": " + m.name + "</h4><p>" + "</p></div>"
        #end
        
      #end
      
      m.mratings.last(1).each do |r|
        if r.user.avatar_file_name
          html = html + "<div align=center>"+ (showImage2(:medium, r.user, true)) + "<h4>" + r.comment + "</h4><p>" + r.user.name + " " + r.user.lastname + "</p></div>"
        end
      end
    end
    
    html = html +  "</div>"
    return html.html_safe
end

def carousel(signages, size, text)
    html = ""
    html = html +  '<div class="owl-show">'
    signages.each do |s|
      if s.avatar_file_name == nil
        html = html + "<div>" + image_tag(image_def("Signage", "", ""), :size => size, class:"card-img-top img-responsive" ) + "</div>"
      else
        html = html + "<div align=center>"+ (image_tag s.avatar(:native), class:"img-rounded img-rounded") + "<h2>" + s.name + "</h2>" + s.description + "</div>"
      end
    end
    html = html +  "</div>"
    return html.html_safe
end

def carousel2(mobject, size)
    html = ""
    if mobject.mdetails == nil
      html = html + image_tag(mobject.mtype + ".png", :size => size, class:"card-img-top img-responsive" )
    else
      if mobject.mdetails.count == 0
        html = html + image_tag(mobject.mtype + ".png", :size => size, class:"card-img-top img-responsive" )
      else
        html = html +  '<div class="owl-show">'
        mobject.mdetails.each do |p|
          
          html = html + "<div class='row'>"

            html = html + "<div class='col-xs=12'>"
              if p.avatar_file_name == nil
                html = html + "<div>" + image_tag(image_def("objekte", mobject.mtype, mobject.msubtype), :size => size, class:"card-img-top img-responsive" ) + "</div>"
              else
                html = html + "<div>"+ (image_tag p.avatar(size), class:"img-rounded") + "</div>"
              end
            html = html + "</div>"
              
            html = html + "<div class='col-xs=12 mdetailalign'>"
              if p.name 
                html = html + "<b>"+p.name + "</b><br>"
              end
              if p.description
                html = html + p.description + "<br>"
              end
            html = html + "</div>"

            html = html + "<div class='col-xs=12'>"
              if p.document_file_name
                html = html + link_to(p.document.url, target: "_blank") do 
                  content_tag(:i, nil, class:"btn btn-primary fa fa-cloud-download")
                end
              end
            html = html + "</div>"

          html = html + "</div>"
              
        end
        html = html +  "</div>"
      end
    end
    return html.html_safe
end

def align_text(txt)
    len = 30
    if txt == nil
        text = ""
    else
        if txt.length >= len
          text = txt[0,len]
        else
          text = txt
        end
    end
    return text + "..."
end


def build_medialistNew(items, cname, par)

  priceAnz = 0
  sensorAnz = 0

  html_string = ""
  html_string = html_string + '<div class="container">'
    html_string = html_string + '<div class="row">'
      #html_string = html_string + '<div class="col-md-12 text-center">'
        #html_string = html_string + '<h2 class="service-title pad-bt15">übersicht</h2>'
        #html_string = html_string + '<p class="sub-title pad-bt15">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod<br>tempor incididunt ut labore et dolore magna aliqua.</p>'
        #html_string = html_string + '<hr class="bottom-line">'
      #html_string = html_string + '</div>'

  items.each do |item|
    
    show = true
    if cname == "nopartners"
      if par[:user_id]
        @customer = Customer.where('owner_type=? and owner_id=? and partner_id=?', "User", par[:user_id], item.id).first
      end
      if par[:company_id]
        @customer = Customer.where('owner_type=? and owner_id=? and partner_id=?', "Company", par[:company_id], item.id).first
      end
      if @customer
        show = false
      end
    end
    
    if item and show
      
        html_string = html_string + '<div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 col-xs-12">'
        
          #bei mobject corporate design
          color = $graph_color2
          if items.table_name == "mobjects"
            if item.owner_type == "Company"
              if item.owner.company_params.first
                if item.owner.company_params.first.color1 and item.owner.company_params.first.color1 != ""
                  color = item.owner.company_params.first.color1
                end
              end
            end
          end
          html_string = html_string + '<div class="blog-sec" style="border-left: 10px solid '+color+'">'
          
            #**************************************************************************************************************
            #IMAGE BLOCK
            #**************************************************************************************************************
            html_string = html_string + '<div class="blog-img">'
            case items.table_name
              when "games"
                  html_string = html_string + '<i class="fa fa-calendar"></i> '
                  html_string = html_string + "<b>" + item.created_at.strftime("%d.%m.%Y") + "</b> "
                  html_string = html_string + item.mcategory.name
              when "deputies"
                  html_string = html_string + showImage2(:medium, User.find(item.userid), true)
               when "appparams"
                  html_string = html_string + image_tag(item.right+".png", :size => "250x250")
              when "users", "companies"
                html_string = html_string + showImage2(:medium, item, true)
              when "mdetails"
                html_string = html_string + showImage2(:medium, item, false)
              when "mobjects"
                html_string = html_string + showFirstImage2(:medium, item, item.mdetails)
              when "madvisors"
                if par == "objekte"
                  html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                end
                if par == "user" or "usersearch"
                  html_string = html_string + showImage2(:medium, item.user, true)
                end
              when "favourits"
                @item = Object.const_get(item.object_name).find(item.object_id)
                if @item
                  html_string = html_string + showImage2(:medium, @item, true)
                end
              when "searches"
                  if par != nil and par != ""
                    html_string = html_string + link_to(showcal_index_path(:filter_id => item.id, :dom => par)) do
                      content_tag(:i, nil, class:"fa fa-" + getinfo(item.mtype.to_sym)["info"], style:"font-size:8em") 
                    end
                  else
                    html_string = html_string + "<soft_padding>"
                    case item.search_domain
                      when "personen"
                        html_string = html_string + link_to(users_path(:filter_id => item.id)) do
                          #content_tag(:i, nil, class:"fa fa-question-sign", style:"font-size:8em") 
                          image_tag("abfragen.jpg", :size => :medium)
                        end
                      when "objekte"
                        html_string = html_string + link_to(mobjects_path(:filter_id => item.id)) do
                          #content_tag(:i, nil, class:"fa fa-question-sign", style:"font-size:8em") 
                          image_tag("abfragen.jpg", :size => :medium)
                        end
                      when "institutionen"
                        html_string = html_string + link_to(companies_path(:filter_id => item.id)) do
                          #content_tag(:i, nil, class:"fa fa-question-sign", style:"font-size:8em") 
                          image_tag("abfragen.jpg", :size => :medium)
                        end
                    end
                    html_string = html_string + "</soft_padding>"
                  end
              when "partner_links"
                html_string = html_string + showImage2(:medium, item, false)
            end
          html_string = html_string + '</div>'

          html_string = html_string + '<div class="blog-info">'
            #**************************************************************************************************************
            #IMAGE NAME
            #**************************************************************************************************************
          html_string = html_string + '<h4>'
            case items.table_name
              when "games"
                @u = User.where('email=?', item.player1).first
                if @u
                  html_string = html_string + showImage2(:small, @u, true) 
                  html_string = html_string + @u.name + " " + @u.lastname
                else 
                  html_string = html_string + item.player1
                end
                if item.mcategory.name == "Einzel"
                  html_string = html_string + " : "
                else
                  html_string = html_string + @u.name + " / " + @u.lastname
                end
                @u = User.where('email=?', item.player2).first
                if @u
                  html_string = html_string + showImage2(:small, @u, true) 
                  html_string = html_string + @u.name + " " + @u.lastname
                else 
                  html_string = html_string + item.player2
                end
                if item.mcategory.name == "Doppel"
                  @u = User.where('email=?', item.player3).first
                  if @u
                  html_string = html_string + showImage2(:small, @u, true) 
                    html_string = html_string + @u.name + " " + @u.lastname
                  else 
                    html_string = html_string + item.player3
                  end
                  html_string = html_string + @u.name + " / " + @u.lastname
                  @u = User.where('email=?', item.player4).first
                  if @u
                  html_string = html_string + showImage2(:small, @u, true) 
                    html_string = html_string + @u.name + " " + @u.lastname
                  else 
                    html_string = html_string + item.player4
                  end
                end
                
                
              when "deputies"
                html_string = html_string + User.find(item.userid).name + " " + User.find(item.userid).lastname
              when "appparams"
                html_string = html_string + (I18n.t item.right.to_sym)
              when "users"
                html_string = html_string + item.name + " " + item.lastname
              when "companies", "mdetails"
                html_string = html_string + item.name
              when "mobjects"
                if item.online_pub
                  html_string = html_string + '<i class="fa fa-road"></i>'
                else
                  html_string = html_string + '<i class="fa fa-lock"></i>'
                end
                html_string = html_string + " " + item.name
              when "searches"
                html_string = html_string + item.name
              when "customers"
                @comp = Company.find(item.partner_id)
                html_string = html_string + @comp.name
              when "madvisors"
                if par == "user"
                  html_string = html_string + item.user.name + " " + item.user.lastname
                end
                if par == "objekte"
                  html_string = html_string + item.mobject.name
                end
              when "favourits"
                @item = Object.const_get(item.object_name).find(item.object_id)
                if Object.const_get(item.object_name).to_s == "User"
                    html_string = html_string + @item.name + " " + @item.lastname 
                end
                if Object.const_get(item.object_name).to_s == "Company"
                    html_string = html_string + @item.name 
                end
              when "partner_links"
                if item.name
                    html_string = html_string + item.name + "<br>"
                end
                if item.link
                    html_string = html_string + item.link 
                end
            end
          html_string = html_string + '</h3>'

            #**************************************************************************************************************
            #DETAILS BLOCK
            #**************************************************************************************************************
          html_string = html_string + '<div class="blog-comment">'
          case items.table_name
              when "appparams"
                html_string = html_string + "<trans>"

                html_string = html_string + '<i class="fa fa-pencil"></i>'+ (I18n.t :abo) + '<br><br>'

                if user_signed_in?
                  if par == "user"
                    @charges = item.charges.where('owner_id=? and owner_type=?', current_user.id, "User").order(created_at: :desc)
                  else
                    @charges = item.charges.where('owner_id=? and owner_type=?', current_user.id, "Company").order(created_at: :desc)
                  end
                  startdatum = Date.today
                  @charges.each do |c|
  
                    html_string = html_string + '<i class="fa fa-calendar"></i> '
                    html_string = html_string + c.date_from.strftime("%d-%m-%Y") + "-" + c.date_to.strftime("%d-%m-%Y")
                    
                    if c.date_to > startdatum
                      startdatum = c.date_to
                    end
                    if c.date_to < Date.today
                      proc = 0
                    end  
                    if c.date_from > Date.today
                      proc = 100
                    end
                    if c.date_from <= Date.today and c.date_to >= Date.today
                      days = c.date_to - c.date_from
                      days_used = c.date_to - Date.today
                      proc = (days_used/days*100).to_i
                    end
                    if proc > 0
                      if proc >= 30
                        progresscolor = "success"
                      end
                      if proc > 10 and proc < 30
                        progresscolor = "warning"
                      end
                      if proc <= 10 
                        progresscolor = "danger"
                      end
                      html_string = html_string + '<div class="progress">'
                      html_string = html_string + '<div class="progress-bar progress-bar-' + progresscolor + ' progress-bar-striped" role="progressbar2" aria-valuenow="' + proc.to_s + '" aria-valuemin="0" aria-valuemax="100" style="width:' + proc.to_s + '%">'
                      html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                      html_string = html_string + '</div>'
                      html_string = html_string + '</div>'
                    end
                  end
                
                  if item.fee
                    html_string = html_string + link_to(new_charge_path(:user_id => current_user.id, :appparam_id => item.id, :datum => startdatum, :plan => "monthly")) do
                      content_tag(:i, content_tag(:div,sprintf("%05.2f CHF/m",item.fee/100)), class:"btn btn-submit")
                    end
                    #html_string = html_string + " " + sprintf("%05.2f CHF/Monat",item.fee/100) 
                    #html_string = html_string + "<br><br>"
                    html_string = html_string + link_to(new_charge_path(:user_id => current_user.id, :appparam_id => item.id, :datum => startdatum, :plan => "yearly")) do
                      content_tag(:i, content_tag(:div,sprintf("%05.2f CHF/y",item.fee/10)), class:"btn btn-submit")
                    end
                    #html_string = html_string + " " + sprintf("%05.2f CHF/y",item.fee/10) 
                  end
                else
                      html_string = html_string + content_tag(:i, content_tag(:div,sprintf("%05.2f CHF/m",item.fee/100)), class:"btn btn-submit")
                      html_string = html_string + content_tag(:i, content_tag(:div,sprintf("%05.2f CHF/y",item.fee/10)), class:"btn btn-submit")
                end
                html_string = html_string + "</trans>"

              when "games"
                html_string = html_string + '<i class="fa fa-trophy"></i>'
                @r = item.results.last
                if @r
                  if @r.set1H and @r.set1G
                    html_string = html_string + @r.set1H.to_s + ":" + @r.set1G.to_s + " "
                  end
                  if @r.set2H and@r. set2G
                    html_string = html_string + @r.set2H.to_s + ":" + @r.set2G.to_s + " "
                  end
                  if @r.set3H and @r.set3G
                    html_string = html_string + @r.set3H.to_s + ":" + @r.set3G.to_s + " "
                  end
                  if @r.set4H and @r.set4G
                    html_string = html_string + @r.set4H.to_s + ":" + @r.set4G.to_s + " "
                  end
                  if @r.set5H and @r.set5G
                    html_string = html_string + @r.set5H.to_s + ":" + @r.set5G.to_s + " "
                  end
                end

              when "deputies"
                html_string = html_string + '<i class="fa fa-calendar"></i> '
                if item.date_from and item.date_to
                  html_string = html_string + item.date_from.strftime("%d-%m-%Y") + "-" + item.date_to.strftime("%d-%m-%Y")
                else
                  html_string = html_string + (I18n.t :unlimited)
                end

              when "mdetails"
                html_string = html_string + '<i class="fa fa-pencil"></i> '
                html_string = html_string + item.description + '<br>' if item.description

              when "users"
                html_string = html_string +  item.email

              when "companies"
                html_string = html_string + '<i class="fa fa-folder-open"></i>'
                html_string = html_string + " " + item.mcategory.name
                html_string = html_string + '<br><br>'
                html_string = html_string + contactChip(item.user)

              when "mobjects"
                html_string = html_string + '<i class="fa fa-folder-open"></i> '
                html_string = html_string + " " + item.mcategory.name + "<br>"
                html_string = html_string + contactChip(item.owner)

                when "madvisors"
                    html_string = html_string + '<i class="fa fa-folder-open"></i> '
                    html_string = html_string + item.grade.to_s + "<br>"
                    if item.mobject.mtype == "projekte"
                      html_string = html_string + '<i class="fa fa-euro"></i> '
                      if !item.rate
                        item.rate = 0
                      end
                      html_string = html_string + sprintf("%5.2f",item.rate) + "<br>"
                    end
                    if item.mobject.mtype == "veranstaltungen"
                      html_string = html_string + '<i class="fa fa-safari"></i> '
                      html_string = html_string + item.created_at.strftime("%d.%m.%Y") 
                    end

              when "favourits"
                html_string = html_string + @item.geo_address + '<br>'

              when "searches"
                #html_string = html_string + "<anzeigetext>" + item.name + "</anzeigetext><br>"
                if item.search_domain == "object"
                  html_string = html_string + '<i class="fa fa-folder-open"></i> '
                  html_string = html_string + item.mtype + "<br>" 
                  html_string = html_string + item.msubtype.to_s + '<br>'
                end
                html_string = html_string + '<i class="fa fa-question-sign"></i> '
                html_string = html_string + 'Anzahl ' + item.counter.to_s + '<br>'
                
          end
          html_string = html_string + '<br><br>'
          
          html_string = html_string + '<mediabutton>'

          html_string = html_string + '<div class="mediabuttonpanel">'
          #if (Date.today - item.created_at.to_date).to_i < 5
          #    html_string = html_string + '<i class="fa fa-calendar mediabutton"></i> '
          #end 

          #check credentials
          access = false
          if user_signed_in?
            case cname
              when "partner_links"
                if current_user.id = item.company.user_id or isdeputy(item.company.user_id)
                  access = true
                end

              when "users"
  	            #html_string = html_string + link_to(new_email_path(:m_to_id => item.id, :m_from_id => current_user.id, :back_url => request.original_url)) do 
                  #content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-envelope mediabutton")
                #end
                if par == "usersearch"
    	            html_string = html_string + link_to(new_game_path(:user_id => item.id)) do 
                    content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-check mediabutton")
                  end
                end
                if item.id == current_user.id or isdeputy(item)
                  access=true
                end 

              when "companies"
                if item.user_id == current_user.id or isdeputy(item.user)
                  access=true
                end 

              when "favourits", "searches"
                if item.user_id == current_user.id or isdeputy(item.user)
                  access=true
                end 

              when "mobjects", "partners"
                if cname == "mobjects"
                    # if item.mtype == "projekte" and item.madvisors.where('role=? and user_id=?',item.mtype, current_user.id).count > 0
                    #   html_string = html_string + link_to(timetracks_path(:mobject_id => item.id)) do 
                    #     content_tag(:i, nil, class:"btn btn-primary fa fa-pencil")
                    #   end
                    # end
                  if isowner(item) or isdeputy(item.owner)
                    access = true
                  end
                end
                
              when "nopartners"
                access = true
                
              when "deputies"
                if isowner(item)
                  access = true
                end
               when "madvisors"
                if item.user_id == current_user.id or isdeputy(item.mobject.owner) or current_user.id = item.mobject.owner_id
                  access = true
                end

              when "mdetails"
                if item.document_file_name
    	            html_string = html_string + link_to(item.document.url, target: "_blank") do 
                    content_tag(:i, nil, class:"fa fa-cloud-download mediabutton")
                  end
                end
                if isowner(item.mobject) or isdeputy(item.mobject.owner)
                  access = true
                end

             end
          end

          #kein Info button wenn kein weiterer drill down
          if cname != "mdetails" and cname != "madvisors" and cname != "partner_links" and cname != "appparams"
            html_string = html_string + link_to(item, :topic => "info") do 
              content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-info")
            end
          end
 
          if access
            case cname 
              when "partner_links"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_partner_link_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "companies"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_company_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "users"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_user_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
               when "favourits"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
               when "madvisors"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
                html_string = html_string + "<br><br>"

              when "deputies"
  	            html_string = html_string + link_to(edit_deputy_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default fa fa-wrench")
                end
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger fa fa-trash pull-right")
                end

              when "partners"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_customer_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
  	            html_string = html_string + link_to(accounts_path(:customer_id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-list")
                end

              when "nopartners"
                if par[:user_id]
    	            html_string = html_string + link_to(new_customer_path(:user_id => par[:user_id], :partner_id => item)) do 
                    content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-pencil")
                  end
                end
                if par[:company_id]
    	            html_string = html_string + link_to(new_customer_path(:company_id => par[:company_id], :partner_id => item)) do 
                    content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-pencil")
                  end
                end
              when "searches"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_search_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "mdetails"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_mdetail_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "mobjects"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_mobject_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end

            end

          end
              html_string = html_string + '</div>' #blog-comment
            html_string = html_string + '</div>' #blog-info
          html_string = html_string + '</div>'
        html_string = html_string + '</div>'
      html_string = html_string + '</div>'

    end #item show
  end # loop item
  html_string = html_string + '</div>'
  if par == "panel"
    html_string = html_string + '</div>'
  end
  return html_string.html_safe
end

def showFirstImage2(size, item, details)
    case size
      when :medium
        ssize = "250x250"
      when :small
        ssize = "50x50"
    end
    html_string = link_to item do
      if details.count > 0
        pic = details.first
        if pic.avatar_file_name
          image_tag pic.avatar(size), class:"img-rounded img-responsive"
        else
          image_tag(item.mtype + ".png", :size => ssize, class:"img-responsive")
        end
      else
        image_tag(item.mtype + ".png", :size => ssize, class:"img-responsive")
      end
    end
    return html_string.html_safe
end

def showImage2(size, item, linkit)
    case size
      when :medium
        ssize = "250x250"
      when :small
        ssize = "50x50"
    end
    if linkit
      html_string = link_to(item) do
        if item.avatar_file_name
            image_tag(item.avatar(size), class:"img-responsive")
        else
          case item.class.name
            when "User"
              image_tag("spieler.png", :size => ssize, class:"card-img-top img-responsive" )
            when "Company"
              image_tag("sportstaetten.png", :size => ssize, class:"card-img-top img-responsive" )
            else
              image_tag("no_pic.jpg", :size => ssize, class:"card-img-top img-responsive" )
          end
        end
      end
    else
      if item.avatar_file_name
          html_string = image_tag(item.avatar(size), class:"img-responsive")
      else
        case item.class.name
          when "User"
            html_string = image_tag("person.png", :size => "50x50", class:"card-img-top img-responsive" )
          when "Company"
            html_string = image_tag("company.png", :size => "50x50", class:"card-img-top img-responsive" )
          else
            html_string = image_tag("no_pic.jpg", :size => "50x50", class:"card-img-top img-responsive" )
        end
      end
    end
    return html_string.html_safe
end

def header(header)
    html_string = ""
        html_string = html_string + '<div class="panel-body ueberschrift">'
        html_string = html_string + "<h3>"+header+"</h3>"
      html_string = html_string + "</div>"
    return html_string.html_safe
end

def header_comp(header, color)
    html_string = ""
      if color 
        html_string = html_string + '<div class="panel-body" id="header">'
      else
        html_string = html_string + '<div class="panel-body ueberschrift">'
      end
        html_string = html_string + "<h3>"+header+"</h3>"
      html_string = html_string + "</div>"
    return html_string.html_safe
end

def header_cicd(header, company, mobject)
  color1 = $graph_color2
  color2 = $grey
  if company  
    if company.company_params.first 
      if company.company_params.first.color1 and company.company_params.first.color1 != ""
        color1 = company.company_params.first.color1
      end
      if company.company_params.first.color2 and company.company_params.first.color2 != ""
        color2 = company.company_params.first.color2
      end
    end
  end
  if mobject
    if mobject.owner_type == "Company"
      if mobject.owner.company_params.first 
        if mobject.owner.company_params.first.color1 and mobject.owner.company_params.first.color1 != ""
          color1 = mobject.owner.company_params.first.color1
        end
        if mobject.owner.company_params.first.color2 and mobject.owner.company_params.first.color2 != ""
          color2 = mobject.owner.company_params.first.color2
        end
      end
    end
  end
  html_string = ""
  html_string = html_string + '<div class="panel-body" style="background-color:' + color1 + '; color:' + color2 + '">'
    html_string = html_string + "<h3>"+header+"</h3>"
  html_string = html_string + "</div>"
  return html_string.html_safe
end

def header3(objekt, item, topic, format)

    pos = topic.to_s.index("_")
    if pos > 0
      infosymbol = (topic[pos+1..topic.length-1]).to_sym
    else
      infosymbol = topic
    end
    
  if format
    html_string = "<div class='col-xs-12'><div class='panel-heading header'><li_header>" + (I18n.t infosymbol) + "</li_header></div></div>"
  else
    html_string = "<div class='panel-heading header'><li_header>" + (I18n.t infosymbol) + "</li_header></div>"
  end
  
  html_string = html_string + action_buttons2(objekt, item, topic)

  return html_string.html_safe
end

def getTopicName(topic)
  pos = topic.to_s.index("_")
  if pos > 0
    infosymbol = (topic[pos+1..topic.length-1]).to_sym
  else
    infosymbol = topic
  end
  return (I18n.t infosymbol)
end

def navigate2(object, item, topic)

  html_string = ""

  html_string = html_string + "<nav class='navbar navbar-default'>"
    html_string = html_string + "<div class='navbar-header'>"
      html_string = html_string + "<button type='button' class='navbar-toggle' data-toggle='collapse' data-target='#myMenuNavbar'>"
      html_string = html_string + "<span class='icon-bar'></span>"
      html_string = html_string + "<span class='icon-bar'></span>"
      html_string = html_string + "<span class='icon-bar'></span>"
      html_string = html_string + "</button>"
    html_string = html_string + "</div>"
    
    html_string = html_string + "<div class='collapse navbar-collapse' id='myMenuNavbar'>"
      html_string = html_string + "<ul class='nav navbar-nav navbar-left'>"

  case object
    when "tabellen"
      html_string = html_string + build_nav2("tabellen",item,"tabellen_kategorien",1)
      
    when "personen"
      html_string = html_string + build_nav2("personen",item,"personen_info",1)
      if user_signed_in?
        html_string = html_string + build_nav2("personen",item,"personen_spiele",Game.where('user_id=?',current_user.id).count)
        html_string = html_string + build_nav2("personen",item,"personen_favoriten",item.favourits.count)
        html_string = html_string + build_nav2("personen",item,"personen_stellvertretungen", item.deputies.count)
        html_string = html_string + build_nav2("personen",item,"personen_sportstaetten",item.companies.count)
      end
      html_string = html_string + build_nav2("personen",item,"personen_zugriffsberechtigungen", item.credentials.count)

      when "institutionen"
        html_string = html_string + build_nav2("institutionen",item,"institutionen_info",1)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_plaetze",item.mobjects.where('mtype=? ',"plaetze").count)
        if item.partner
          html_string = html_string + build_nav2("institutionen",item,"institutionen_partnerlinks", item.partner_links.count)
        end

      when "objekte"
        if item.owner_type == "User"
          html_string = html_string + build_nav2("personen",item.owner,"personen_"+item.mtype,1)
        end
        if item.owner_type == "Company"
          html_string = html_string + build_nav2("institutionen",item.owner,"institutionen_"+item.mtype,1)
        end
        html_string = html_string + build_nav2("objekte",item,"objekte_info",1)
        html_string = html_string + build_nav2("objekte",item,"objekte_details",item.mdetails.where('mtype=?',"details").count)
        if user_signed_in?
          if isowner(item) or isdeputy(item.owner)
            html_string = html_string + build_nav2("objekte",item,"objekte_projektberechtigungen", item.madvisors.where('role=?',item.mtype).count)
          end
        end
    end

    html_string = html_string + '</ul>'
    html_string = html_string + '</div>'
    html_string = html_string + '</nav>'
    
    html_string = html_string + action_buttons4(object, item, topic)

    return html_string.html_safe
    
end

def build_nav2(domain, item, domain2, anz)
  
  pos = domain2.index("_")
  infosymbol = (domain2[pos+1..domain2.length-1]).to_sym
  txt = getinfo2(infosymbol)["infotext"]

  case domain
    when "personen"
      unipath = user_path(:id => item.id, :topic => domain2)
    when "institutionen"
      unipath = company_path(:id => item.id, :topic => domain2)
    when "objekte"
      unipath = mobject_path(:id => item.id, :topic => domain2)
    when "tabellen"
      unipath = home_index9_path
  end

  html_string = ""

  if (!user_signed_in? and $activeapps.include?(domain2)) or (user_signed_in? and getUserCreds.include?(domain2)) or (user_signed_in? and current_user.superuser)
    if anz > 0
        badge = content_tag(:span, anz.to_s, class:"badge menu-badge")
    else
        badge = ""
    end 
    if @topic == domain2
      sel = "active menu-selected"
    else
      if anz > 0 
        sel = "menu-active"
      else
        sel = "menu-inactive"
      end
    end
    html_string = html_string + '<li class="nav-item">'
      html_string = html_string + link_to(unipath, :class => "nav-link " + sel) do
        #content_tag(:span, " " + getinfo2(infosymbol)["infotext"] + content_tag(:span,anz.to_s, class:"badge"), class:"fa fa-" + getinfo2(infosymbol)["info"] )
        #content_tag(:span, content_tag(:b, " " + getinfo2(infosymbol)["infotext"]) + " " + badge, class:"fa fa-" + getinfo2(infosymbol)["info"])
        content_tag(:span, content_tag(:b, " " + txt) + " " + badge, class:"fa fa-" + getinfo2(infosymbol)["info"])
      end
    html_string = html_string + "</li>"
  end
  return html_string.html_safe
end

def action_buttons4(object_type, item, topic)
  
  html_string = ''

  case object_type 
    when "kategorien"
      html_string = html_string + link_to(home_index9_path) do
        content_tag(:i, " " + (I18n.t :uebersicht), class: "btn btn-default fa fa-list")
      end
      html_string = html_string + link_to(new_mcategory_path(:ctype => item)) do
        content_tag(:i, " " + (I18n.t :kategorie) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus")
      end

    when "personen"
      case topic
        when "personen_info"
            html_string = html_string + link_to(users_path) do
              content_tag(:i, " " + (I18n.t :suchen), class:"btn btn-default fa fa-search") 
            end
          if user_signed_in? 
            if $activeapps.include?("personen_favoriten") or isdeputy(item) or current_user.superuser
                html_string = html_string + link_to(new_favourit_path(:object_name => "User", :object_id => item.id, :user_id => current_user.id)) do
                  content_tag(:i, " " + (I18n.t :fav), class: "btn btn-default fa fa-user")
                end
            end
            if current_user.id == item.id or isdeputy(item) or current_user.superuser
                  html_string = html_string + link_to(edit_user_path(item)) do
                    content_tag(:i, " "+(I18n.t :aendern), class: "btn btn-primary fa fa-wrench")
                  end
                  html_string = html_string + link_to(item, method: :delete, data: { confirm: (I18n.t :sindsiesicher)})  do
                      content_tag(:i, " " + (I18n.t :loeschen), class: "btn btn-danger fa fa-trash red")
                  end
            end
              html_string = html_string + link_to(new_webmaster_path(:object_name => "User", :object_id => item.id, :user_id => current_user.id)) do
                content_tag(:i, " " + (I18n.t :fraud), class: "btn btn-warning fa fa-ban orange")
              end
          end

       when "personen_sportstaetten"
          html_string = html_string + link_to(companies_path) do
            content_tag(:i, " " + (I18n.t :institutionenuebersicht), class: "btn btn-default fa fa-search")
          end
          if user_signed_in?
            if current_user.id == item.id or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_company_path(:user_id => current_user.id)) do
                content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus orange") 
              end
            end
          end

        when "personen_spiele"
          html_string = html_string + link_to(games_path) do
            content_tag(:i, " " + (I18n.t subtopic(topic).to_sym) + " " + (I18n.t :suchen), class: "btn btn-default fa fa-search")
          end
          if user_signed_in?
            if current_user.id == item.id or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_mobject_path(:user_id => current_user.id, :mtype => subtopic(topic))) do
                content_tag(:i, " " + (I18n.t subtopic(topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus orange")
              end
            end
          end

        when "personen_stellvertretungen"
             if user_signed_in?
              if (item.id == current_user.id) or current_user.superuser
                html_string = html_string + link_to(deputies_path(:user_id => item.id)) do
                  content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange")
                end
              end
             end

      end

    when "institutionen"
      case topic
        when "institutionen_info"
          html_string = html_string + link_to(companies_path(:page => session[:page]), title: (I18n.t :institutionen)) do
            content_tag(:i, " " + (I18n.t :suchen), class:"btn btn-default fa fa-search") 
          end
          if user_signed_in?
            if current_user.id == item.user_id or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(edit_company_path(item), title: (I18n.t :bearbeiten)) do
                content_tag(:i, " "+(I18n.t :aendern), class: "btn btn-primary fa fa-wrench")
              end
              html_string = html_string + link_to(item, method: :delete, data: { confirm: (I18n.t :sindsiesicher) }) do
                  content_tag(:i, " " + (I18n.t :loeschen), class: "btn btn-danger fa fa-trash red")
              end
            end
            html_string = html_string + link_to(new_webmaster_path(:object_name => "Company", :object_id => item.id, :user_id => current_user.id)) do
              content_tag(:i, " " + (I18n.t :fraud), class: "btn btn-warning fa fa-ban orange")
            end
            if $activeapps.include?("institutionen_favoriten") or current_user.superuser
              if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
                html_string = html_string + link_to(new_favourit_path(:object_name => "Company", :object_id => item.id, :user_id => current_user.id)) do
                  content_tag(:i, " " + (I18n.t :fav), class: "btn btn-default fa fa-heart")
                end
              end
            end
            if false
            if $activeapps.include?("institutionen_transaktionen") or current_user.superuser
              if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
                html_string = html_string + link_to(listaccount_index_path :user_id => current_user.id, :user_id_ver => nil, :company_id_ver => item.id, :ref => (I18n.t :verguetungan)+item.name, :object_name => "Company", :object_id => item.id, :amount => nil) do
                  content_tag(:i, " " + (I18n.t :trx), class: "btn btn-default fa fa-euro")
                end
              end
            end
            end
          end

        when "institutionen_plaetze"
          html_string = html_string + link_to(mobjects_path :mtype => getTopicName(topic)) do
            content_tag(:i, " " + (I18n.t subtopic(topic).to_sym) + " " + (I18n.t :suchen), class: "btn btn-default fa fa-search")
          end
          if user_signed_in?
            if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_mobject_path :company_id => item.id, :mtype => subtopic(topic), :msubtype => nil) do
                content_tag(:i, " " + (I18n.t subtopic(topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus orange")
              end
            end
          end
          
        when "institutionen_partnerlinks"
          if user_signed_in?
            if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_partner_link_path :company_id => item.id) do
                content_tag(:i, " " + (I18n.t subtopic(topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-default fa fa-plus orange")
              end
            end
          end

        when "institutionen_stellvertretungen"
             if user_signed_in?
              if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
                html_string = html_string + link_to(deputies_path(:company_id => item.id)) do
                  content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :hinzufuegen), class:"btn btn-default fa fa-plus orange")
                end
              end
             end

      end

    when "objekte"
       case topic
          when "objekte_info"
             html_string = html_string + link_to(mobjects_path(:mtype =>item.mtype)) do
              content_tag(:i, " "+ (I18n.t :suchen), class:"btn btn-default fa fa-search") 
             end
             if user_signed_in?
               if isowner(item) or isdeputy(item.owner)
         	        html_string = html_string + link_to(edit_mobject_path(item), title: (I18n.t :bearbeiten)) do
                    content_tag(:i, " "+(I18n.t :aendern), class: "btn btn-primary fa fa-wrench")
                  end
               end
               if isowner(item)
         	        html_string = html_string + link_to(item, method: :delete, data: { confirm: (I18n.t :sindsiesicher) } ) do
                    content_tag(:i, " " + (I18n.t :loeschen), class: "btn btn-danger fa fa-trash red")
                   end
               end
               html_string = html_string + link_to(new_webmaster_path(:object_name => "Mobject", :object_id => item.id, :user_id => current_user.id)) do
                  content_tag(:i, " " + (I18n.t :fraud), class: "btn btn-warning fa fa-ban orange")
               end
             end

          when "objekte_details"
              if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  html_string = html_string + link_to(new_mdetail_path(:mobject_id => item.id, :mtype => "details")) do
                    content_tag(:i, " " + (I18n.t :details) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus") 
                  end
               end
              end

          when "objekte_projektberechtigungen"
             if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  html_string = html_string + link_to(madvisors_path :user_id => item.owner_id, :mobject_id => item.id, :role => item.mtype) do
                      content_tag(:i, " " + (I18n.t getTopicName(topic).to_sym) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
                  end
                  if topic != "objekte_gruppenmitglieder"
                    groups = item.owner.mobjects.where('mtype=?',"gruppen")
                    groups.each do |g|
                      html_string = html_string + link_to(mobject_path :mobject_id => item.id, :topic => topic, :group_id => g.id) do
                          content_tag(:i, " " + g.name + " " + (I18n.t :hinzufuegen), class:"btn btn-default fa fa-plus orange") 
                      end
                    end
                  end

               end
              end

      end

  end
  return html_string.html_safe
end

def getinfo2(topic)
  
  info = "question_mark"
  if I18n.t topic
    infotext = (I18n.t topic)
  else
    infotext = "unbekannt"
  end

  case topic
    when :spieler
      info = "user"
    when :sportstaetten
      info = "map-marker"
    when :spiele
      info = "trophy"
    when :plaetze
      info = "clone"

    when :rollen
      info = "user"
    when :params
      info = "cog"
    when :sponsorantraege
      info = "heart"
    when :menu
      info = "medium"
    when :notizen
      info = "paperclip"
    when :stellvertretungen
      info = "share"
    when :signstat
      info = "signal"
    when :signlocshow, :signkamshow
      info = "film"
    when :signcal
      info = "calendar"
    when :projekte
      info = "tasks"
    when :institutionen
      info = "industry"
    when :zeiterfassung
      info = "safari"
    when :ressourcenplanung
      info = "first-order"
    when :gruppen
      info = "th"
    when :zugriffsberechtigungen, :projektberechtigungen
      info = "lock"
     when :news
      info = "alert"
    when :spieler, :personen, :geburtstage, :ansprechpartner, :anmeldungen, :gruppenmitglieder, :umfrageteilnehmer, :teilnehmerveranstaltung, :kalendergeburtstage
      info = "user"
    when :vermietungen
      info = "retweet"
    when :sensoren, :sensordaten
      info = "thermometer"
    when :ausschreibungen, :kalenderausschreibungen
      info = "pencil"
    when :publikationen, :kalenderpublikationen, :ausgaben, :ausgabe
      info = "book"
    when :artikel
      info = "font"
    when :umfragen, :fragen, :meineabfragen
      info = "question-circle"
    when :innovationswettbewerbe
      info = "cog"
    when :veranstaltungen, :kalenderveranstaltungen
      info = "glass"
    when :ausflugsziele
      info = "camera"
    when :werbeflaechen
      info = "blackboard"
    when :angebote
      info = "shopping-cart"
    when :angebotestandard
      info = "ban"
    when :angeboteaktion, :aktionen, :kalenderaktionen
      info = "exclamation-sign"
    when :stellenanzeigen, :kalenderstellenanzeigen
      info = "briefcase"
    when :kleinanzeigen
      info = "clipboard"
    when :stellenanzeigensuchen, :kleinanzeigensuchen, :details
      info = "search"
    when :stellenanzeigenanbieten, :kleinanzeigenanbieten
      info = "filter"
    when :crowdfunding, :kalendercrowdfunding
      info = "share"
    when :crowdfundingspenden
      info = "gift"
    when :crowdfundingbelohnungen, :tickets
      info = "qrcode"
    when :crowdfundingzinsen
      info = "signal"
    when :kalender, :kalendereintraege, :kalender, :kalendervermietungen
      info = "calendar"
    when :ideen, :einstellungen
      info = "cog"
    when :crowdfundingbeitraege, :transaktionen, :cftransaktionen, :charges
      info = "euro"
    when :bewertungen
      info = "star"
    when :favoriten, :sponsorenengagements
      info = "heart"
    when :kundenbeziehungen
      info = "check"
    when :emails
      info = "envelope"
    when :zugriffsberechtigungen, :projektberechtigungen
      info = "lock"
    when :kampagnen, :dskampagnen
      info = "bullhorn"
    when :dsstandorte
      info = "blackboard"
    when :jury
      info = "education"
    when :preise
      info = "gift"
    when :bewertungskriterien
      info = "pencil"
    when :projektdashboard, :aktivitaeten, :cfstatistik
      info = "dashboard"
    when :auftragscontrolling
      info = "cube"
    when :substruktur
      info = "cog"
    when :fragen
      info = "question-sign"
    when :ausgaben
      info = "dublicate"
    when :blog
      info = "comment"
    when :tickets, :eintrittskarten
      info = "barcode"
    when :show
      info = "film"
    when :kontobeziehungen
      info = "film"
    when :mappositionen, :mappositionenfavoriten, :standorte
      info = "map-marker"
    when :partnerlinks
      info = "globe"
    when :ausschreibungsangebote
      info = "book"
    when :berechtigungen
      info = "lock"
    when :kategorien
      info = "folder-open"
    when :info
      info = "bookmark"
  end
  ret = Hash.new
  ret = {"info" => info, "infotext" => infotext}
  return ret
end

def build_services

    html_string = ""
    html_string = html_string + '<div class="container"><div class="row">'
    html_string = html_string + '<div class="col-md-12 text-center">'
    #html_string = html_string + '<h2 class="service-title pad-bt15">Services</h2>'
    #html_string = html_string + '<p class="sub-title pad-bt15">folgende Services sind aktuell verfügbar.</p>'
    #html_string = html_string + '<hr class="bottom-line">'
    html_string = html_string + '</div>'

    if user_signed_in?  
      init_apps
      creds = getUserCreds
    else
      creds = init_apps
    end

    domain = "spieler"
    if creds.include?("hauptmenue_"+domain)
        path = users_path(:mtype => nil, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end
    
    domain = "sportstaetten"
    if creds.include?("hauptmenue_"+domain)
        path = companies_path(:mtype => nil, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    if user_signed_in?
      domain = "spiele"
      if creds.include?("hauptmenue_"+domain)
          path = games_path(:mtype => nil, :msubtype => nil)
          html_string = html_string + simple_menue(domain, path)
      end
    end

    html_string = html_string + '</div></div>'

    return html_string.html_safe
    
end

def build_myservices

    html_string = ""

    creds = init_apps
    if user_signed_in?  
      creds = getUserCreds
    end
    
    domains = []
    domains << "spieler"
    domains << "sportstaetten"
    domains << "spiele"
    

    html_string = html_string + '<div class="container"><div class="row">'

    #html_string = html_string + '<h2 class="service-title pad-bt15">myServices</h2>'
    #html_string = html_string + '<hr class="bottom-line">'
    html_string = html_string + '</div>'

    for i in 0..domains.count-1 do
      if user_signed_in? and creds.include?("hauptmenue_"+domains[i])
          path = user_path(:id => current_user.id, :topic => "personen_"+domains[i])

          html_string = html_string + '<div class="col-md-4 col-sm-6 col-xs-12">'
            html_string = html_string + '<div class="service-item">'
              html_string = html_string + '<h3><span>'
              html_string = html_string + link_to(path) do
                content_tag(:i, nil, class:"fa fa-" + getinfo2(domains[i].to_sym)["info"]) 
              end
              html_string = html_string + '</span>'+domains[i]+'</h3>'
              html_string = html_string + '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>'
            html_string = html_string + '</div>'
            
          html_string = html_string + '</div>'

      end
    end

    html_string = html_string + '</div></div>'
    
    return html_string.html_safe
    
end

def simple_menue (domain, path)
  html_string= ""
  html_string = html_string + '<div class="col-md-4 col-sm-6 col-xs-12">'
    html_string = html_string + '<div class="service-item">'
      html_string = html_string + '<h3><span>'
      html_string = html_string + link_to(path) do
        #content_tag(:i, nil, class:"fa fa-" + getinfo2(domain.to_sym)["info"], style:"font-size:2em") 
        content_tag(:i, nil, class:"fa fa-" + getinfo2(domain.to_sym)["info"]) 
      end
      html_string = html_string + '</span>'+domain+'</h3>'
      html_string = html_string + '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>'
    html_string = html_string + '</div>'
  html_string = html_string + '</div>'
  return html_string.html_safe
end

def build_kachel_access(topic, mode, user)

  html_string = ""
  
  html_string = html_string + '<table class="table table-striped>"'
  
  appparams = Appparam.where('domain=?',topic)
  appparams.each do |a|
  
    if mode == "system"
      if a.access
          thumbnail_state = 'fa fa-check ac'
        else
          thumbnail_state = 'fa fa-ban noac'
      end
      cpath = appparams_path(:id => a.id)
    end

    if mode == "user"
      @credential = user.credentials.where('appparam_id=?',a.id).first
      if !@credential
          @cred = Credential.new
          @cred.appparam_id = a.id
          @cred.user_id = user.id
          @cred.access = a.access
          @cred.save
          @credential = user.credentials.where('appparam_id=?',a.id).first
      end
      if @credential.access
          thumbnail_state = 'fa fa-check ac'
        else
          thumbnail_state = 'fa fa-ban noac'
      end
      cpath = user_path(:id => @credential.user_id, :credential_id => @credential.id, :topic => "personen_zugriffsberechtigungen")
    end
    
    html_string = html_string + "<tr>"
      
        if false
        html_string = html_string + link_to(cpath) do
          content_tag(:div, nil, class:"col-xs-4 col-sm-4 col-md-3 col-lg-2") do 
            content_tag(:div, nil, class:"thumbnail " + thumbnail_state, align:"center") do
              content_tag(:span, nil) do
                info_size = "4"
                content_tag(:i, nil, class:"fa fa-" + getinfo2(a.right.to_sym)["info"], style:"font-size:" + info_size + "em") + content_tag(:small_cal, "<br>".html_safe + (I18n.t a.right))
              end
            end
          end
        end
        end

      html_string = html_string + "<td>"
        html_string = html_string + link_to(cpath) do
          content_tag(:i, nil, class: thumbnail_state)
        end
      html_string = html_string + "</td>"
      html_string = html_string + "<td>"
          info_size = "1"
          html_string = html_string + content_tag(:i, nil, class: "fa fa-" + getinfo2(a.right.to_sym)["info"], style:"font-size:" + info_size + "em") + " " + content_tag(:small_cal, (I18n.t a.right))
      html_string = html_string + "</td>"
      
    html_string = html_string + "</tr>"

  end    
  html_string = html_string + "</table>"
  return html_string.html_safe
end

def image_def (objekt, mtype, msubtype)
    case objekt
      when $app_name
        pic = "connect.jpg"
      when "personen"
        pic = "user.jpg"
      when "institutionen"
        pic = "company.jpg"
      when "objekte"
        pic = "no_pic.jpg"
    end
end

def url_with_protocol(url)
    /^http/i.match(url) ? url : "http://#{url}"
end

def init_apps

  apps = Appparam.all
  if !apps or apps.count==0
  
    @array = []

    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "spieler", "access" => true, "info" => "news", "fee" => 0}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "sportstaetten", "access" => true, "info" => "news", "fee" => 0}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "spiele", "access" => true, "info" => "news", "fee" => 0}
    @array << hash


    hash = Hash.new
    hash = {"domain" => "personen", "right" => "info", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "spiele", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "stellvertretungen", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "zugriffsberechtigungen", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "sportstaetten", "access" => true, "info" => "news"}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "info", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "plaetze", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "partnerlinks", "access" => true, "info" => "news"}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "info", "access" => true, "info" => "news"}
    @array << hash

    for i in 0..@array.length-1
      c = Appparam.new
      c.domain = @array[i]["domain"]
      if @array[i]["parent_domain"]
        c.parent_domain = @array[i]["parent_domain"]
      else
        c.parent_domain = "root"
      end
      c.right = @array[i]["right"]
      c.info = @array[i]["info"]
      c.access = @array[i]["access"]
      if @array[i]["domain"] == "hauptmenue"
        c.fee = @array[i]["fee"]
      else
        c.fee = 0
      end
      c.save
    end
    apps = Appparam.all
  end

  $activeapps = []
  apps.each do |a|
    $activeapps << a.domain+"_"+a.right if a.access
  end
  
  return $activeapps

end

def init_credentials
  @appparams = Appparam.all
  @appparams.each do |a|
    if a.access
      c = Credential.new
      c.user_id = current_user.id
      c.appparam_id = a.id
      c.access = a.access
      c.save
    end
  end
end

def getUserCreds
  credapps = []
  if current_user.superuser
    appparams = Appparam.all
    appparams.each do |a|
      credapps << a.domain+"_"+a.right
    end
  else  
    creds = current_user.credentials
    if !creds or creds.count==0
      init_credentials
    end
    creds.each do |c|
      if $activeapps.include?(c.appparam.domain+"_"+c.appparam.right)
        credapps << c.appparam.domain+"_"+c.appparam.right if c.access
      end
    end
  end
  return credapps
end

def buildQRCode(content)
  qr = RQRCode::QRCode.new(content, size: 12, :level => :h)
  qr_img = qr.to_img
  qr_img.resize(200, 200).save("ticketqrcode.png")
  img = File.open("ticketqrcode.png")
end

def current_period(p, item)
  case p
  when "Jahr"
      if Date.today.strftime("%m").to_i == item
          return true
      end
  when "Monat"
      if Date.today.strftime("%W").to_i == item
          return true
      end
  when "Woche"
      if Date.today == item
          return true
      end
  end
  return false
end

def subtopic(topic)
  pos = topic.to_s.index("_")
  if pos > 0
    topic = (topic[pos+1..topic.length-1])
  else
    topic = topic
  end
  return topic
end

def isowner(mobject)
  zugriff = false
  if (mobject.owner_type == "User" and mobject.owner_id == current_user.id) or (mobject.owner_type == "Company" and mobject.owner.user_id == current_user.id)
    zugriff = true
  end
  return zugriff
end

def isdeputy(item)
  zugriff = false
  if current_user.superuser
    zugriff = true
  else
    @deputies = item.deputies
    @deputies.each do |d|
      if d.userid == current_user.id
        if d.date_from and d.date_to
          if d.date_from <= Date.today and d.date_to >= Date.today
            zugriff = true
          end
        else
          zugriff = true
        end
      end
    end
  end
  return zugriff
end

def zugriffsliste(mobjects, mtype, user)
  array = []
  if user_signed_in?
      if mobjects != nil or mobject.count > 0
        mobjects.each do |m|
            #wenn Owner ok or deputy of Owner oder Antragsteller bei Sponsoranträge
            if isowner(m) or isdeputy(m.owner) or isrequester(m) or iscompany_sponsor_res(m)
              array << m.id
            end
            #wenn Berechtigung ok
            m.madvisors.where('role=?',mtype).each do |a|
              if current_user.id == a.user_id
                if !array.include?(m.id)
                  array << m.id
                end
              end
            end
        end
      end
  end
  return array
end

def contactChip(owner)
  html = '<div class="chip">'
  html = html + showImage2(:small,owner,true)
  if owner.class.name == "User"
    html = html + owner.name[0] + "." + owner.lastname
  end
  if owner.class.name == "Company"
    if owner.name.length <= 15
      html = html + " " + owner.name
    else
      html = html + " " + owner.name[0..15]
    end
  end
  html = html + '</div>'
  return html.html_safe
end

end    