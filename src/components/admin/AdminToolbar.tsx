import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Menu, Globe, LogOut, Settings, BarChart3, Users, BookOpen, GraduationCap, TrendingUp } from 'lucide-react';
import { useIsMobile } from '@/hooks/use-mobile';
import { supabase } from '@/integrations/supabase/client';
import { useToast } from '@/hooks/use-toast';

interface AdminToolbarProps {
  title: string;
  subtitle?: string;
  rightContent?: React.ReactNode;
}

const AdminToolbar: React.FC<AdminToolbarProps> = ({ title, subtitle, rightContent }) => {
  const navigate = useNavigate();
  const isMobile = useIsMobile();
  const { toast } = useToast();

  const handleNavigateToOverview = () => {
    navigate('/admin?tab=overview');
  };

  const handleNavigateToAnalytics = () => {
    navigate('/admin?tab=analytics');
  };

  const handleNavigateToUsers = () => {
    navigate('/admin?tab=users');
  };

  const handleNavigateToCourses = () => {
    navigate('/admin?tab=courses');
  };

  const handleNavigateToClasses = () => {
    navigate('/admin?tab=classes');
  };

  const handleNavigateToHome = () => {
    navigate('/');
  };

  const handleLogout = async () => {
    try {
      await supabase.auth.signOut();
      localStorage.removeItem('currentUser');
      localStorage.removeItem('userRole');

      toast({
        title: "Đăng xuất thành công",
        description: "Bạn đã đăng xuất khỏi hệ thống",
      });

      navigate('/');
    } catch (error) {
      console.error('Error logging out:', error);
      toast({
        title: "Lỗi",
        description: "Không thể đăng xuất. Vui lòng thử lại.",
        variant: "destructive",
      });
    }
  };

  // Mobile Layout
  if (isMobile) {
    return (
      <div className="bg-white shadow-lg border-b sticky top-0 z-50">
        <div className="px-4 py-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3 min-w-0 flex-1">
                          <div className="w-8 h-8 bg-[#02458b] rounded-lg flex items-center justify-center flex-shrink-0">
                <Settings className="h-4 w-4 text-white" />
              </div>
              <div className="min-w-0 flex-1">
              <h1 className="text-lg font-bold text-[#02458b] truncate">
                  {title}
                </h1>
                {subtitle && (
                  <p className="text-xs text-gray-500 truncate">{subtitle}</p>
                )}
              </div>
            </div>

            <div className="flex items-center space-x-2">
              {rightContent && (
                <div className="mr-2">
                  {rightContent}
                </div>
              )}
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button
                    variant="ghost"
                    size="sm"
                    className="p-2 hover:bg-gray-100"
                  >
                    <Menu className="h-5 w-5" />
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end" className="w-56">
                  <DropdownMenuItem onClick={handleNavigateToOverview}>
                    <BarChart3 className="mr-2 h-4 w-4" />
                    <span>Tổng quan</span>
                  </DropdownMenuItem>
                  <DropdownMenuItem onClick={handleNavigateToAnalytics}>
                    <TrendingUp className="mr-2 h-4 w-4" />
                    <span>Thống kê</span>
                  </DropdownMenuItem>
                  <DropdownMenuItem onClick={handleNavigateToUsers}>
                    <Users className="mr-2 h-4 w-4" />
                    <span>Quản lí người dùng</span>
                  </DropdownMenuItem>
                  <DropdownMenuItem onClick={handleNavigateToCourses}>
                    <BookOpen className="mr-2 h-4 w-4" />
                    <span>Quản lí khóa học</span>
                  </DropdownMenuItem>
                  <DropdownMenuItem onClick={handleNavigateToClasses}>
                    <GraduationCap className="mr-2 h-4 w-4" />
                    <span>Quản lí lớp học</span>
                  </DropdownMenuItem>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem onClick={handleNavigateToHome}>
                    <Globe className="mr-2 h-4 w-4" />
                    <span>Quay lại trang chủ</span>
                  </DropdownMenuItem>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem onClick={handleLogout} className="text-red-600">
                    <LogOut className="mr-2 h-4 w-4" />
                    <span>Đăng xuất</span>
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            </div>
          </div>
        </div>
      </div>
    );
  }

  // Desktop Layout
  return (
    <div className="bg-white shadow-lg border-b">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-20">
          <div className="flex items-center space-x-4">
            <div className="w-12 h-12 bg-[#02458b] rounded-xl flex items-center justify-center shadow-lg">
              <Settings className="h-7 w-7 text-white" />
            </div>
            <div>
              <h1 className="text-3xl font-bold text-[#02458b]">
                {title}
              </h1>
              {subtitle && (
                <p className="text-gray-600 mt-1">{subtitle}</p>
              )}
            </div>
          </div>

          <div className="flex items-center space-x-4">
            {rightContent && (
              <div>
                {rightContent}
              </div>
            )}
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button
                  variant="outline"
                  className="flex items-center space-x-2 hover:bg-[#02458b]/10 border-[#02458b]/20 text-[#02458b]"
                >
                  <Menu className="h-4 w-4" />
                  <span>Menu</span>
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end" className="w-64">
                <DropdownMenuItem onClick={handleNavigateToOverview}>
                  <BarChart3 className="mr-3 h-5 w-5" />
                  <span className="text-base">Tổng quan</span>
                </DropdownMenuItem>
                <DropdownMenuItem onClick={handleNavigateToUsers}>
                  <Users className="mr-3 h-5 w-5" />
                  <span className="text-base">Quản lí người dùng</span>
                </DropdownMenuItem>
                <DropdownMenuItem onClick={handleNavigateToCourses}>
                  <BookOpen className="mr-3 h-5 w-5" />
                  <span className="text-base">Quản lí khóa học</span>
                </DropdownMenuItem>
                <DropdownMenuItem onClick={handleNavigateToClasses}>
                  <GraduationCap className="mr-3 h-5 w-5" />
                  <span className="text-base">Quản lí lớp học</span>
                </DropdownMenuItem>
                <DropdownMenuSeparator />
                <DropdownMenuItem onClick={handleNavigateToHome}>
                  <Globe className="mr-3 h-5 w-5" />
                  <span className="text-base">Quay lại trang chủ</span>
                </DropdownMenuItem>
                <DropdownMenuSeparator />
                <DropdownMenuItem onClick={handleLogout} className="text-red-600">
                  <LogOut className="mr-3 h-5 w-5" />
                  <span className="text-base">Đăng xuất</span>
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AdminToolbar;