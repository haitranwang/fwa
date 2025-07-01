import React, { useState, useEffect } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { CalendarIcon, TrendingUp, Users, Eye, BarChart3, AlertCircle, Shield } from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend } from 'recharts';
import { supabase } from '@/integrations/supabase/client';
import { useToast } from '@/hooks/use-toast';
import { useUserRole } from '@/hooks/useUserRole';
import { format, subDays, startOfDay, endOfDay } from 'date-fns';
import { vi } from 'date-fns/locale';

interface AnalyticsData {
  id: string;
  date: string;
  visit_count: number;
  unique_visitors: number;
  page_views: number;
  created_at: string;
  updated_at: string;
}

interface ChartData {
  date: string;
  displayDate: string;
  visits: number;
  uniqueVisitors: number;
  pageViews: number;
}

const AnalyticsTab = () => {
  const [analyticsData, setAnalyticsData] = useState<AnalyticsData[]>([]);
  const [chartData, setChartData] = useState<ChartData[]>([]);
  const [loading, setLoading] = useState(true);
  const [dateRange, setDateRange] = useState('7'); // 7, 14, 30 days
  const [error, setError] = useState<string | null>(null);
  const { toast } = useToast();
  const { userRole, isLoading: roleLoading } = useUserRole();

  useEffect(() => {
    if (!roleLoading && userRole === 'admin') {
      fetchAnalyticsData();
    }
  }, [dateRange, userRole, roleLoading]);

  const fetchAnalyticsData = async () => {
    try {
      setLoading(true);
      setError(null);

      const daysBack = parseInt(dateRange);
      const startDate = format(subDays(new Date(), daysBack - 1), 'yyyy-MM-dd');
      const endDate = format(new Date(), 'yyyy-MM-dd');

      const { data, error } = await supabase
        .from('website_analytics')
        .select('*')
        .gte('date', startDate)
        .lte('date', endDate)
        .order('date', { ascending: true });

      if (error) {
        throw error;
      }

      setAnalyticsData(data || []);

      // Transform data for chart
      const transformedData: ChartData[] = (data || []).map(item => ({
        date: item.date,
        displayDate: format(new Date(item.date), 'dd/MM', { locale: vi }),
        visits: item.visit_count,
        uniqueVisitors: item.unique_visitors,
        pageViews: item.page_views
      }));

      setChartData(transformedData);
    } catch (error: any) {
      console.error('Error fetching analytics data:', error);
      const errorMessage = error?.message || "Không thể tải dữ liệu thống kê. Vui lòng thử lại.";
      setError(errorMessage);
      toast({
        title: "Lỗi",
        description: errorMessage,
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  const getTotalStats = () => {
    if (!analyticsData.length) return { totalVisits: 0, totalUniqueVisitors: 0, totalPageViews: 0, avgVisitsPerDay: 0 };

    const totalVisits = analyticsData.reduce((sum, item) => sum + item.visit_count, 0);
    const totalUniqueVisitors = analyticsData.reduce((sum, item) => sum + item.unique_visitors, 0);
    const totalPageViews = analyticsData.reduce((sum, item) => sum + item.page_views, 0);
    const avgVisitsPerDay = Math.round(totalVisits / analyticsData.length);

    return { totalVisits, totalUniqueVisitors, totalPageViews, avgVisitsPerDay };
  };

  const stats = getTotalStats();

  // Kiểm tra phân quyền
  if (roleLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Đang kiểm tra quyền truy cập...</p>
        </div>
      </div>
    );
  }

  if (!userRole || userRole !== 'admin') {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <Shield className="h-12 w-12 text-red-500 mx-auto mb-4" />
          <h3 className="text-lg font-semibold text-gray-900 mb-2">Truy cập bị từ chối</h3>
          <p className="text-gray-600">Chỉ quản trị viên mới có thể xem thống kê truy cập.</p>
        </div>
      </div>
    );
  }

  // Hiển thị lỗi nếu có
  if (error && !loading) {
    return (
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <h2 className="text-2xl font-bold text-gray-900">Thống kê truy cập</h2>
          <Button onClick={fetchAnalyticsData} variant="outline" size="sm">
            <BarChart3 className="h-4 w-4 mr-2" />
            Thử lại
          </Button>
        </div>

        <Card>
          <CardContent className="flex items-center justify-center h-64">
            <div className="text-center">
              <AlertCircle className="h-12 w-12 text-red-500 mx-auto mb-4" />
              <h3 className="text-lg font-semibold text-gray-900 mb-2">Có lỗi xảy ra</h3>
              <p className="text-gray-600 mb-4">{error}</p>
              <Button onClick={fetchAnalyticsData} variant="outline">
                Thử lại
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    );
  }

  const CustomTooltip = ({ active, payload, label }: any) => {
    if (active && payload && payload.length) {
      return (
        <div className="bg-white p-4 border border-gray-200 rounded-lg shadow-lg">
          <p className="font-semibold text-gray-800 mb-2">{`Ngày: ${label}`}</p>
          {payload.map((entry: any, index: number) => (
            <p key={index} className="text-sm" style={{ color: entry.color }}>
              {`${entry.name}: ${entry.value.toLocaleString()}`}
            </p>
          ))}
        </div>
      );
    }
    return null;
  };

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <h2 className="text-2xl font-bold text-gray-900">Thống kê truy cập</h2>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          {[1, 2, 3, 4].map((i) => (
            <Card key={i} className="animate-pulse">
              <CardHeader className="pb-2">
                <div className="h-4 bg-gray-200 rounded w-3/4"></div>
              </CardHeader>
              <CardContent>
                <div className="h-8 bg-gray-200 rounded w-1/2"></div>
              </CardContent>
            </Card>
          ))}
        </div>
        <Card className="animate-pulse">
          <CardHeader>
            <div className="h-6 bg-gray-200 rounded w-1/3"></div>
          </CardHeader>
          <CardContent>
            <div className="h-80 bg-gray-200 rounded"></div>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold text-gray-900">Thống kê truy cập</h2>
          <p className="text-gray-600 mt-1">Theo dõi lượt truy cập website theo thời gian</p>
        </div>

        <div className="flex items-center space-x-4">
          <Select value={dateRange} onValueChange={setDateRange}>
            <SelectTrigger className="w-40">
              <SelectValue placeholder="Chọn khoảng thời gian" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="7">7 ngày qua</SelectItem>
              <SelectItem value="14">14 ngày qua</SelectItem>
              <SelectItem value="30">30 ngày qua</SelectItem>
            </SelectContent>
          </Select>

          <Button onClick={fetchAnalyticsData} variant="outline" size="sm">
            <BarChart3 className="h-4 w-4 mr-2" />
            Làm mới
          </Button>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Tổng lượt truy cập</CardTitle>
            <TrendingUp className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.totalVisits.toLocaleString()}</div>
            <p className="text-xs text-muted-foreground">
              Trung bình {stats.avgVisitsPerDay.toLocaleString()}/ngày
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Người dùng duy nhất</CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.totalUniqueVisitors.toLocaleString()}</div>
            <p className="text-xs text-muted-foreground">
              {analyticsData.length > 0 ? Math.round(stats.totalUniqueVisitors / analyticsData.length).toLocaleString() : 0}/ngày
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Lượt xem trang</CardTitle>
            <Eye className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.totalPageViews.toLocaleString()}</div>
            <p className="text-xs text-muted-foreground">
              {analyticsData.length > 0 ? Math.round(stats.totalPageViews / analyticsData.length).toLocaleString() : 0}/ngày
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Tỷ lệ trang/phiên</CardTitle>
            <BarChart3 className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {stats.totalVisits > 0 ? (stats.totalPageViews / stats.totalVisits).toFixed(1) : '0.0'}
            </div>
            <p className="text-xs text-muted-foreground">
              Trang/lượt truy cập
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Chart */}
      <Card>
        <CardHeader>
          <CardTitle>Biểu đồ lượt truy cập</CardTitle>
          <CardDescription>
            Thống kê lượt truy cập website trong {dateRange} ngày qua
          </CardDescription>
        </CardHeader>
        <CardContent>
          {chartData.length > 0 ? (
            <ResponsiveContainer width="100%" height={400}>
              <LineChart data={chartData} margin={{ top: 5, right: 30, left: 20, bottom: 5 }}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis
                  dataKey="displayDate"
                  tick={{ fontSize: 12 }}
                  tickLine={{ stroke: '#e0e0e0' }}
                />
                <YAxis
                  tick={{ fontSize: 12 }}
                  tickLine={{ stroke: '#e0e0e0' }}
                />
                <Tooltip content={<CustomTooltip />} />
                <Legend />
                <Line
                  type="monotone"
                  dataKey="visits"
                  stroke="#2563eb"
                  strokeWidth={3}
                  name="Lượt truy cập"
                  dot={{ fill: '#2563eb', strokeWidth: 2, r: 4 }}
                  activeDot={{ r: 6, stroke: '#2563eb', strokeWidth: 2 }}
                />
                <Line
                  type="monotone"
                  dataKey="uniqueVisitors"
                  stroke="#16a34a"
                  strokeWidth={2}
                  name="Người dùng duy nhất"
                  dot={{ fill: '#16a34a', strokeWidth: 2, r: 3 }}
                />
                <Line
                  type="monotone"
                  dataKey="pageViews"
                  stroke="#dc2626"
                  strokeWidth={2}
                  name="Lượt xem trang"
                  dot={{ fill: '#dc2626', strokeWidth: 2, r: 3 }}
                />
              </LineChart>
            </ResponsiveContainer>
          ) : (
            <div className="flex items-center justify-center h-80 text-gray-500">
              <div className="text-center">
                <BarChart3 className="h-12 w-12 mx-auto mb-4 text-gray-300" />
                <p>Không có dữ liệu thống kê</p>
                <p className="text-sm">Dữ liệu sẽ được cập nhật tự động</p>
              </div>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
};

export default AnalyticsTab;
