class Booking < GroupSessionsUser
  scope :upcoming, -> { joins(:group_session).where('group_sessions.ended_at IS NULL') }

  class << self
    def find(group_session, user)
      find_by(group_session_id: group_session.id, user_id: user.id)
    end

    def create(group_session, user)
      if group_session.bookable_by?(user)
        super(group_session: group_session, user: user)
        notify_create_by_email(group_session, user)
        Event.invite(group_session, user.email)
      end
    end

    def destroy(group_session, user)
      if session = find(group_session, user)
        session.destroy
        notify_destroy_by_email(group_session, user)
      end
    end

    private
    def notify_create_by_email(group_session, user)
      HostNotifier.participant_joined(group_session).deliver
      ParticipantNotifier.group_session_booked(group_session, user).deliver
    end

    def notify_destroy_by_email(group_session, user)
      HostNotifier.participant_canceled(group_session).deliver
      ParticipantNotifier.booking_canceled(group_session, user).deliver
    end
  end
end
