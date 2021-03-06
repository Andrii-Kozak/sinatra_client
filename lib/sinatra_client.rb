require "sinatra_client/version"
require "rest-client"
require "dotenv/load"
require 'uri'

class SinatraClient
  attr_accessor :current_user_id, :url

  def initialize(current_user_id = nil)
    @current_user_id = current_user_id
    @url = URI::HTTP.build(userinfo: "#{ENV['API_NAME']}:#{ENV['API_PASSWORD']}", host: ENV['SINATRA_HOST'], port: ENV['SINATRA_PORT'], path: '/api/v1')
  end

  def get_user_posts(user_id, page)
    url.path << "/users/#{user_id}/posts"
    url.query = URI.encode_www_form({ page: page })
    parse RestClient.get(url.to_s)
  end

  def create_post(post)
    url.path << '/posts'
    parse RestClient.post(url.to_s, post)
  end

  def delete_post(post_id)
    url.path << "/posts/#{post_id}"
    url.query = URI.encode_www_form({ current_user: current_user_id })
    parse RestClient.delete(url.to_s)
  end

  def delete_posts_for(postable_id, postable_type)
    url.path << "/postable/#{postable_id}/posts"
    url.query = URI.encode_www_form({ postable_type: postable_type })
    parse RestClient.delete(url.to_s)
  end

  def get_group_posts(group_id, page)
    url.path << "/groups/#{group_id}/posts"
    url.query = URI.encode_www_form({ page: page })
    parse RestClient.get(url.to_s)
  end

  def get_user_posts_comment(post_id)
    url.path << "/posts/#{post_id}/comments"
    parse RestClient.get(url.to_s)
  end

  def create_comment_for_post(post_id, comment)
    url.path << "/posts/#{post_id}/comments"
    parse RestClient.post(url.to_s, comment)
  end

  def delete_comment(post_id, comment_guid)
    url.path << "/posts/#{post_id}/comments/#{comment_guid}"
    url.query = URI.encode_www_form({ current_user: current_user_id })
    parse RestClient.delete(url.to_s)
  end

  def create_or_delete_like(post_id, liker_id)
    url.path << "/posts/#{post_id}/toggle_like"
    parse RestClient.post(url.to_s, liker_id)
  end

  def get_likers(post_id)
    url.path << "/posts/#{post_id}/likers"
    parse RestClient.get(url.to_s)
  end

  private

  def parse(response)
    JSON.parse(response.body)
  end
end  
