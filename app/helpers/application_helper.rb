module ApplicationHelper

  def crop_text(text,len = 30)
    return "" if text.blank?
    return text if text.size <= len
    text[0,30] + "..."
  end

  def the_organization
    NewAccountOfferings::TheOrganizationShortName
  end

end
