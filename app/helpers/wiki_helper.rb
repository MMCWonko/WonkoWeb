module WikiHelper
  def gh_wiki_base_path
    "https://github.com/#{Rails.application.secrets.wiki_github_repo}/wiki"
  end

  def gh_wiki_page_path(page)
    page = page.filename_stripped unless page.is_a? String
    "#{gh_wiki_base_path}/#{page}"
  end

  def gh_wiki_edit_path(page)
    "#{gh_wiki_page_path page}/_edit"
  end

  def gh_wiki_new_path
    "#{gh_wiki_base_path}/_new"
  end

  def gh_wiki_page_history_path(page)
    "#{gh_wiki_page_path page}/_history"
  end

  def gh_wiki_clone_url
    "https://github.com/#{Rails.application.secrets.wiki_github_repo}.wiki.git"
  end
end
