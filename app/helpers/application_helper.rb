module ApplicationHelper

  def crop_text(text,len = 30)
    return "" if text.blank?
    return h(text) if text.size <= len
    shown = text[0,len] + "..."
    '<span title="'.html_safe + h(text) + '">'.html_safe + h(shown) + '</span>'.html_safe
  end

  def the_organization
    NewAccountOfferings::TheOrganizationShortName
  end

end
