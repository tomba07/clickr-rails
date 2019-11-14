# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

classes = SchoolClass.create([{ name: '5a'}, { name: '5b' }])
students = Student.create([{ name: 'Max', school_class: classes.first, seat_row: 1, seat_col: 1 }, { name: 'Maria', school_class: classes.first, seat_row: 1, seat_col: 2 }])
lessons = Lesson.create([{ name: 'Lesson 1', school_class: classes.first }, { name: 'Lesson 2', school_class: classes.first }])
questions = Question.create([{ name: 'Question 1', school_class: classes.first, lesson: lessons.first }, { name: 'Question 2', school_class: classes.first, lesson: lessons.first }])
users = User.create([{ email: 'f@ftes.de', password: 'password', password_confirmation: 'password', school_class: classes.first }])