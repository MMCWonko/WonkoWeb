require 'gollum-lib'

class WikiController < ApplicationController
  add_breadcrumb 'Wiki', :wiki_index_path

  def perform_caching
    false
  end

  def index
    skip_authorization
    redirect_to wiki_path wiki.index_page
  end

  def show
    skip_authorization
    @page = page_for params[:page]

    set_meta_tags title: ['Wiki', @page.title], author: @page.version.author.name

    path = []
    @page.name.split('/').each do |name|
      add_breadcrumb name, wiki_path((path + [name]).join '/')
      path << name
    end
  end

  private

  def wiki
    @wiki ||= Gollum::Wiki.new Rails.application.secrets.wiki_path, base_path: 'wiki'
  end

  def page_for(path)
    name = extract_name(path) || wiki.index_page
    dir = extract_dir path
    wiki.paged name, dir
  end

  def extract_dir(path)
    return '' if path.nil?
    last_slash = path.rindex '/'
    if last_slash
      path[0, last_slash]
    else
      ''
    end
  end

  def extract_name(path)
    File.basename path if path[-1, 1] != '/'
  end
end
