class UserMailer < ApplicationMailer
  default from: 'postmaster@mg.mymatch.com'

  add_template_helper(EmailHelper)
 
  def welcome_email(user)
    @url = $appurl
    @user = user
    mail(to: user.email, subject: (I18n.t :welcometo))
    #mail(to: "wurmhorst63@gmail.com", subject: 'Welcome to My Awesome Site')
  end
  
  def send_email(user_to, user_from, header, text)
    @url = $appurl
    @user_to = user_to
    @user_from = user_from
    @text = text
    mail(from: user_from.email, to: user_to.email, subject: header)
    #mail(to: "wurmhorst63@gmail.com", subject: 'Welcome to My Awesome Site')
  end
  
  def user_access_info(user, header, text, mobject)
    @url = $appurl
    @user = user
    @text = text
    @mobject = mobject
    @header = header
    mail(to: user.email, subject: header)
    #mail(to: "wurmhorst63@gmail.com", subject: 'Welcome to My Awesome Site')
  end
  
  def user_sponsoring_info(user, mobject, status)
    @url = $appurl
    @user = user
    @status = status
    @mobject = mobject
    @param = mobject.owner.company_params.first
    @text = ""
    if @param
      case @status
        when "beantragt"
          @text = @param.sponsoring_init
        when "in Prüfung"
          @text = @param.sponsoring_init
        when "abgelehnt"
          @text = @param.sponsoring_nok
        when "genehmigt"
          @text = @param.sponsoring_ok
        when "genehmigt mit Anpassungen"
          @text = @param.sponsoring_ok_change
      end
    end
    mail(to: user.email, subject: "Sponsoring Antrag" + " " + @mobject.name)
    #mail(to: "wurmhorst63@gmail.com", subject: 'Welcome to My Awesome Site')
  end
end
