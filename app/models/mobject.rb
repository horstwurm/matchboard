class Mobject < ActiveRecord::Base

belongs_to :owner, polymorphic: true
belongs_to :mcategory

has_many :mdetails, dependent: :destroy
has_many :mratings, dependent: :destroy
has_many :madvisors, dependent: :destroy
has_many :mcalendars, dependent: :destroy
has_many :mstats, dependent: :destroy
has_many :msponsors, dependent: :destroy
has_many :tickets, as: :owner, dependent: :destroy 
has_many :comments, dependent: :destroy 
has_many :editions, dependent: :destroy 
has_many :mlikes, dependent: :destroy 
has_many :questions, dependent: :destroy 
has_many :timetracks, dependent: :destroy 
has_many :plannings, dependent: :destroy 
has_many :ideas, dependent: :destroy 
has_many :crits, dependent: :destroy
has_many :prices, dependent: :destroy
has_many :sensors, dependent: :destroy

before_validation :update_geo_address
geocoded_by :geo_address
after_validation :geocode

def update_geo_address
  self.geo_address = self.address1.to_s + " " + address2.to_s + " " + address3.to_s
end


def self.search(cw, year, filter, mtype, msubtype, search, parent)
if cw and year
      start_date = Date.commercial(year,cw,1)
      end_date = Date.commercial(year,cw,7)
      if msubtype
          if search
              where('status=? and name LIKE ? and mtype=? and msubtype=? and active=? and ((date_from >=? and date_from<=?) or (date_to>=? and date_to<=?) or (date_from<=? and date_to>=?))', "OK", "%#{search}%", mtype, msubtype, true, start_date, end_date, start_date, end_date, start_date, end_date)
          else     
              where('status=? and mtype=? and msubtype=? and active=? and ((date_from >=? and date_from<=?) or (date_to>=? and date_to<=?) or (date_from<=? and date_to>=?))', "OK", mtype, msubtype, true, start_date, end_date, start_date, end_date, start_date, end_date)
          end
      else
          if search
              where('status=? and name LIKE ? and mtype=? and active=? and ((date_from >=? and date_from<=?) or (date_to>=? and date_to<=?) or (date_from<=? and date_to>=?))', "OK", "%#{search}%", mtype, true, start_date, end_date, start_date, end_date, start_date, end_date)
          else
              where('status=? and mtype=? and active=? and ((date_from >=? and date_from<=?) or (date_to>=? and date_to<=?) or (date_from<=? and date_to>=?))', 'OK', mtype, true, start_date, end_date, start_date, end_date, start_date, end_date)
          end
      end
    else
        if filter
            @search = Search.find(filter)
            where(@search.build_sql)
        else
            if search
                if msubtype
                    where('status=? and mtype=? and msubtype=? and active=? and name LIKE ?',"OK",  mtype, msubtype, true, "%#{search}%")
                else
                    where('status=? and mtype=? and active=? and name LIKE ?', "OK", mtype, true, "%#{search}%")
                end
            else
                if msubtype
                    where('status=? and mtype=? and msubtype=? and active=?', "OK", mtype, msubtype, true)
                else
                    if parent and mtype == "Projekte"
                        where('parent=? and status=? and mtype=? and active=?', parent, "OK", mtype, true)
                    else
                        where('status=? and mtype=? and active=?', "OK", mtype, true)
                    end
                end
            end
        end
    end
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
