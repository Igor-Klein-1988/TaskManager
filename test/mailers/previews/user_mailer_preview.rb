# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/user_mailer/task_created
  def task_created
    task = Task.last
    email = User.last.email

    params = { email: email, task: task }
    UserMailer.with(params).task_created
  end

  # http://localhost:3000/rails/mailers/user_mailer/task_updated
  def task_updated
    task = Task.last
    email = task.author.email

    UserMailer.with({ email: email, task: task }).task_updated
  end

  # http://localhost:3000/rails/mailers/user_mailer/task_deleted
  def task_deleted
    task = Task.last
    email = task.author.email

    UserMailer.with({ email: email, task: task }).task_deleted
  end
end
