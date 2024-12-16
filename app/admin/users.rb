ActiveAdmin.register User do
  index do
  	column :email
  	column :username                            
    column :first_name                     
    column :last_name
    column :cards_purchased           
    actions                   
  end

  form do |f|                         
    f.inputs "User Details" do       
      f.input :email                  
      f.input :username             
      f.input :first_name
      f.input :last_name
      f.input :cards_purchased
    end                               
    f.buttons                         
  end 
end
