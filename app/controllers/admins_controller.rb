class AdminsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :white_list

  def index
    @message = Message.exists?(state: false)
  end

  def message_list
    @messages = Message.all
  end

  def message_change
    message = Message.find_by(id: params[:id])
    message.state = message.state ? false : true
    message.save
    redirect_to message_list_admins_path
  end

  def new_notice
    @elem = Notice.new
  end

  def create_notice
    notice = Notice.new
    notice.body = params[:notice][:body]
    notice.state = params[:notice][:state]
    notice.save
    twitter(params[:notice][:body])
    flash[:notice] = "#{ notice.body }を追加しました"
    redirect_to new_notice_admins_path
  end

  def create_sheet
    sheet = Sheet.new
    sheet.title = params[:sheet][:title]
    sheet.ability = params[:sheet][:ability]
    sheet.h_ability = params[:sheet][:h_ability]
    sheet.version = params[:sheet][:version]
    sheet.save
    users = User.all
    version = AbilitysheetIidx::Application.config.iidx_version
    users.each { |user| Score.create(user_id: user.id, sheet_id: sheet.id, version: version) }
    flash[:notice] = "#{ sheet.title }を追加しました"
    redirect_to new_sheet_admins_path
  end

  def new_sheet
    @sheet = Sheet.new
    @versions = [['5',    5],
                 ['6',    6],
                 ['7',    7],
                 ['8',    8],
                 ['9',    9],
                 ['10',   10],
                 ['RED',  11],
                 ['HS',   12],
                 ['DD',   13],
                 ['GOLD', 14],
                 ['DJT',  15],
                 ['EMP',  16],
                 ['SIR',  17],
                 ['RA',   18],
                 ['Lin',  19],
                 ['tri',  20],
                 ['SPD',  21],
                 ['PEN',  22]]
  end

  private

  def twitter(message)
    client = twitter_client_get
    tweet = message
    update(client, tweet)
  end

  def twitter_client_get
    keys = File.open(File.join(Rails.root, 'tmp', 'twitter'), 'r').read.chomp.split(',')
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = keys[0]
      config.consumer_secret     = keys[1]
      config.access_token        = keys[2]
      config.access_token_secret = keys[3]
    end
    client
  end

  def update(client, tweet)
    begin
      tweet = (tweet.length > 140) ? tweet[0..139].to_s : tweet
      client.update(tweet.chomp)
    rescue => e
      Rails.logger.error "<<twitter.rake::tweet.update ERROR : #{e.message}>>"
    end
  end
end
