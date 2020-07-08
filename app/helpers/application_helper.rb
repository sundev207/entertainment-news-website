module ApplicationHelper
  def signed_in?
    session[:user_id] != nil
  end

  def is_user?
    edit_link = link_to("Edit", edit_user_path(@user),class: "article-vote")
    delete_link = link_to(" Delete",user_path(@user), method: :delete, data: {confirm: "Are you sure?"},class: "article-vote")
     
    if session[:user_id].to_s != params[:id].to_s
      content_tag(:h3, "You're not allowed to edit this user")
    else
      edit_link + delete_link
    end
  end

  def show_users(users)
    content_tag :ul do
      users.collect do |user|
        concat(content_tag(:li, link_to("#{user.name}", user_path(user.id))))
      end
    end
  end

  def show_articles(articles)
    
    content_tag :div, class: "articles-container" do
      count = 0
      articles.collect do |article|
        art_vote = link_to(content_tag(:span, 'Vote for this article'), article_votes_path(article_id: article.id), 
        class: "article-vote",
        method: :post) if signed_in?
        article_author = content_tag(:strong,"by #{article.author.name}", class: "article-author") + art_vote
        article_title = link_to(content_tag(:h3, article.title),article_path(article),class: "article-title")
        article_text = content_tag(:p, article.text.truncate_words(20), class: "article-summary")
        article_picture = content_tag(:div, nil, style:"background: no-repeat center/cover url('#{rails_blob_url(article.picture) if article.picture.attached?}');", class: "article-image")
        article_category = content_tag(:h3, article.categories.take.name, class: "articles-cat-title")
       
        
        if ((count/2)%2).zero?
          concat(content_tag(:article, 
          article_picture + content_tag(:div, 
            article_category + article_title + article_author + article_text, 
            class: "article-preview" ),class: "d-flex"))
        else
          concat(content_tag(:article, 
          article_picture + content_tag(:div, 
            article_category + article_title + article_author + article_text, 
            class: "article-preview" ),class: "d-flex row-reverse"))
        end
        count+=1
      end
    end
  end

  def show_categories(categories)
    content_tag :div, class: "categories-container" do
      if categories == nil
        article_title = content_tag(:h3, "There's no categories yet")
      end
      categories.collect do |category|
        if category.articles.take != nil
          article_title = content_tag(:h3, category.latest_articles.first.title)
          art_picture = "background: no-repeat center/cover url('#{rails_blob_url(category.latest_articles.first.picture) if category.latest_articles.take.picture.attached?}');"
        else
          article_title = content_tag(:h3, "No articles for this category, GG")
          art_picture = "background: #4e443e"
        end
        category_name = link_to(content_tag(:h3, category.name),articles_path(category),class: "cat-link")
        
        
        concat(content_tag(:article,( category_name + article_title ),style: art_picture, class: "cat-article d-flex flex-column j-content-between" ))
      end
      end
  end
end
