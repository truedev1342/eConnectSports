ActiveAdmin.register PromoCode do
  index do
    column :id
  	column :code
    column :cards
    column :used      
  	column :user_id    
    actions                   
  end

  form do |f|                         
    f.inputs "Promo Code" do       
      f.input :code
      f.input :cards, label: 'How many cards user will get.'
      f.input :used, label: 'Code is used already?'
    end                               
    f.actions                         
  end                               
end
