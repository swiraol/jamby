require 'rails_helper'

feature 'View live hangouts details', :js do
  scenario 'see the links when the session already has them saved' do
    group_session = create(:group_session, live_url: 'http://foo/bar',
                                            broadcast_id: '123abcdefg')
    page = GroupSessionPage.new(group_session)

    logged_in { page.visit }

    expect(page).to have_link(page.join_group_session_link_text,
                              href: 'http://foo/bar')
    expect(page).to have_link(page.watch_on_air_link_text,
                              href: 'http://youtube.com/watch?v=123abcdefg')
  end

  scenario 'see the link to join on the page' do
    skip 'pusher fake sux'

    user = create(:signup)
    group_session = create(:group_session)
    page = GroupSessionPage.new(group_session)

    Booking.create(group_session, user)
    logged_in(user) { page.visit }

    Messenger.notify(group_session, 'session_is_live', { url: 'http://url' })

    expect(page).to have_link(page.join_group_session_link_text, href: 'http://url')
  end

  scenario 'see the youtube link on the page' do
    skip 'pusher fake sux'

    user = create(:signup)
    group_session = create(:group_session)
    page = GroupSessionPage.new(group_session)

    Booking.create(group_session, user)
    logged_in(user) { page.visit }

    Messenger.notify(group_session, 'session_is_live', { youtubeId: 'fooBarBaz' })

    expect(page).to have_link(page.watch_on_air_link_text,
                              href: 'http://youtube.com/watch?v=fooBarBaz')
  end
end
