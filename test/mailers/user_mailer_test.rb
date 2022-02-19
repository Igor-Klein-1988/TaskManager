require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = create(:user)
    @task = create(:task, author: @user)
    @email = @user.email
  end

  test 'task created' do
    params = { email: @email, task: @task }
    email = UserMailer.with(params).task_created

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['noreply@taskmanager.com'], email.from
    assert_equal [@user.email], email.to
    assert_equal 'New Task Created', email.subject
    assert email.body.to_s.include?("Task #{@task.id} was created")
  end

  test 'task update' do
    params = { email: @email, task: @task }
    email = UserMailer.with(params).task_updated

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['noreply@taskmanager.com'], email.from
    assert_equal [@user.email], email.to
    assert_equal 'Task Updated', email.subject
    assert email.body.to_s.include?("Task #{@task.id} was updated")
  end

  test 'task deleted' do
    params = { email: @email, task: @task }
    email = UserMailer.with(params).task_deleted

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['noreply@taskmanager.com'], email.from
    assert_equal [@user.email], email.to
    assert_equal 'Task Deleted', email.subject
    assert email.body.to_s.include?("Task #{@task.id} was deleted")
  end
end
