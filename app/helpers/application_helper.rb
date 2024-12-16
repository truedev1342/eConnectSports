module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    @add_fields_id = id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def app_url
    "https://idigitallsports.com"
  end

  def current_user_invites
    if user_signed_in?
      current_user.memberships.where(:approved => nil).order("created_at DESC")
    end
  end

  def current_user_memberships
    if user_signed_in?
      current_user.memberships.where(:approved => true).order("created_at DESC")
    end
  end

  def notification_count
    if user_signed_in?
      current_user_invites.count
    end
  end

  def total_cards_purchased
    if current_user.cards_purchased == nil || current_user.cards_purchased == ''
      0
    else
      current_user.cards_purchased
    end
  end

  def android_app_link
    "https://play.google.com/store/apps/details?id=com.idigitallsports.app"
  end
end