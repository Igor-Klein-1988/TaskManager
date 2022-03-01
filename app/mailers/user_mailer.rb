class UserMailer < ApplicationMailer
  default from: 'noreply@taskmanager.com'

  def task_created
    @task = params[:task]
    email = params[:email]

    mail(to: email, subject: 'New Task Created')
  end

  def task_updated
    @task = params[:task]
    email = params[:email]

    mail(to: email, subject: 'Task Updated')
  end

  def task_deleted
    @task = params[:task]
    email = params[:email]

    mail(to: email, subject: 'Task Deleted')
  end
end
