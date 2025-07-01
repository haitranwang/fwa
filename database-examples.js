// Ví dụ các cách truy cập database Supabase trong dự án

import { supabase } from '@/integrations/supabase/client';

// 1. Lấy tất cả users
async function getAllUsers() {
  const { data, error } = await supabase
    .from('profiles')
    .select('*');
  
  if (error) {
    console.error('Error:', error);
    return;
  }
  
  console.log('All users:', data);
}

// 2. Lấy user theo email
async function getUserByEmail(email) {
  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('email', email)
    .single();
  
  console.log('User:', data);
}

// 3. Tạo user mới
async function createUser(userData) {
  const { data, error } = await supabase
    .from('profiles')
    .insert([{
      email: userData.email,
      username: userData.username,
      fullname: userData.fullname,
      password: userData.password,
      role: userData.role || 'student'
    }]);
  
  console.log('Created user:', data);
}

// 4. Lấy tất cả courses
async function getAllCourses() {
  const { data, error } = await supabase
    .from('courses')
    .select('*')
    .order('created_at', { ascending: false });
  
  console.log('Courses:', data);
}

// 5. Lấy classes với thông tin course và instructor
async function getClassesWithDetails() {
  const { data, error } = await supabase
    .from('classes')
    .select(`
      *,
      courses(name, description),
      profiles(fullname, email)
    `);
  
  console.log('Classes with details:', data);
}

// 6. Lấy enrollments của một student
async function getStudentEnrollments(studentId) {
  const { data, error } = await supabase
    .from('enrollments')
    .select(`
      *,
      classes(
        name,
        description,
        courses(name)
      )
    `)
    .eq('student_id', studentId);
  
  console.log('Student enrollments:', data);
}

// 7. Cập nhật thông tin user
async function updateUser(userId, updates) {
  const { data, error } = await supabase
    .from('profiles')
    .update(updates)
    .eq('id', userId);
  
  console.log('Updated user:', data);
}

// 8. Xóa user
async function deleteUser(userId) {
  const { data, error } = await supabase
    .from('profiles')
    .delete()
    .eq('id', userId);
  
  console.log('Deleted user:', data);
}

// 9. Thống kê số lượng users theo role
async function getUserStats() {
  const { data, error } = await supabase
    .from('profiles')
    .select('role')
    .then(result => {
      if (result.data) {
        const stats = result.data.reduce((acc, user) => {
          acc[user.role] = (acc[user.role] || 0) + 1;
          return acc;
        }, {});
        console.log('User stats:', stats);
      }
    });
}

// 10. Raw SQL query (nếu cần)
async function runRawSQL() {
  const { data, error } = await supabase
    .rpc('custom_function_name', { param1: 'value1' });
  
  console.log('Raw SQL result:', data);
}

// Sử dụng các functions
// getAllUsers();
// getUserByEmail('admin@example.com');
// getAllCourses();
