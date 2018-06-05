class Mobject < ActiveRecord::Base

belongs_to :owner, polymorphic: true
belongs_to :mcategory

has_many :mdetails, dependent: :destroy
has_many :madvisors, dependent: :destroy
has_many :games, dependent: :destroy

before_validation :update_geo_address
geocoded_by :geo_address
after_validation :geocode

def update_geo_address
  self.geo_address = self.address1.to_s + " " + address2.to_s + " " + address3.to_s
end

def self.search(user, cw, year, filter, mtype, msubtype, search, parent)
# if cw and year
#       start_date = Date.commercial(year,cw,1)
#       end_date = Date.commercial(year,cw,7)
#       if msubtype
#           if search
#               where('(online_pub=? or id IN (?)) and status=? and name LIKE ? and mtype=? and msubtype=? and active=? and ((date_from >=? and date_from<=?) or (date_to>=? and date_to<=?) or (date_from<=? and date_to>=?))', true, mlist, "OK", "%#{search}%", mtype, msubtype, true, start_date, end_date, start_date, end_date, start_date, end_date)
#           else     
#               where('status=? and mtype=? and msubtype=? and active=? and ((date_from >=? and date_from<=?) or (date_to>=? and date_to<=?) or (date_from<=? and date_to>=?))', true, mlist, "OK", mtype, msubtype, true, start_date, end_date, start_date, end_date, start_date, end_date)
#           end
#       else
#           if search
#               where('(online_pub=? or id IN (?)) and status=? and name LIKE ? and mtype=? and active=? and ((date_from >=? and date_from<=?) or (date_to>=? and date_to<=?) or (date_from<=? and date_to>=?))', true, mlist, "OK", "%#{search}%", mtype, true, start_date, end_date, start_date, end_date, start_date, end_date)
#           else
#               where('(online_pub=? or id IN (?)) and status=? and mtype=? and active=? and ((date_from >=? and date_from<=?) or (date_to>=? and date_to<=?) or (date_from<=? and date_to>=?))', true, mlist, 'OK', mtype, true, start_date, end_date, start_date, end_date, start_date, end_date)
#           end
#       end
#     else
        mlist = []
        if user
            user.madvisors.where('role=?',mtype).each do |a|
                mlist << a.mobject_id
            end
            user.mobjects.each do |m|
                if !mlist.include?(m.id)
                    mlist << m.id
                end
            end
            user.companies.each do |c|
                c.mobjects.each do |m|
                    if !mlist.include?(m.id)
                        mlist << m.id
                    end
                end
            end
        end
        if filter
            @search = Search.find(filter)
            where(@search.build_sql(user))
        else
            if search
                if msubtype
                    where('(online_pub=? or id IN (?)) and status=? and mtype=? and msubtype=? and active=? and name LIKE ?',true, mlist, "OK",  mtype, msubtype, true, "%#{search}%")
                else
                    where('(online_pub=? or id IN (?)) and status=? and mtype=? and active=? and name LIKE ?', true, mlist, "OK", mtype, true, "%#{search}%")
                end
            else
                if msubtype
                    where('(online_pub=? or id IN (?)) and status=? and mtype=? and msubtype=? and active=?', true, mlist, "OK", mtype, msubtype, true)
                else
                    if parent and mtype == "projekte"
                        where('(online_pub=? or id IN (?)) and parent=? and status=? and mtype=? and active=?', true, mlist, parent, "OK", mtype, true)
                    else
                        where('(online_pub=? or id IN (?)) and status=? and mtype=? and active=?', true, mlist, "OK", mtype, true)
                    end
                end
            end
        end
    # end
end

def self.mobshow(mtype,moblist)
    where('mtype=? and (online_pub=? or id IN (?))', mtype, true, moblist)
end

def wo_iterate(wo, include_sub, wolist)
  if include_sub
    subs = Mobject.where("parent=?", wo)
    subs.each do |s|
      wolist << s.id
      wo_iterate(s.id, include_sub, wolist)
    end
  end
end

def avg_rating2()
    #rat = Mrating.where("mobject_id=?", self.id).average(:rating)
    rat = self.mratings.average(:rating)
    if rat != nil
        return rat
    else
        return 0
    end
end

def sum_stat2()
    #rat = Mrating.where("mobject_id=?", self.id).average(:rating)
    rat = self.mstats.sum(:amount)
    if rat != nil
        return rat
    else
        return 0
    end
end

end
