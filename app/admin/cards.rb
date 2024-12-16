ActiveAdmin.register Card do
  index do
    column :id
  	column :user_id
    column :user
  	column :card_name      
    actions                   
  end

  form do |f|                         
    f.inputs "Card Details" do       
      f.input :first_name
      f.input :last_name
      f.input :position
      f.input :highlights
      f.input :team_name
      f.input :card_name
      f.input :sport
      f.input :hometown
      f.input :season
      f.input :year
      f.input :league
      f.input :handed
    end                               
    f.buttons                         
  end                               
end
