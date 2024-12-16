class AdminFooter < ActiveAdmin::Component
  def build?
    super(id: "footer")
    para "Copyright #{Date.today.year} I Dig It All Sports"
  end
end