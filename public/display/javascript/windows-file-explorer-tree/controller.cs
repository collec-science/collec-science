public class FileItemModel
{
    public bool IsDirectory { get; set; }
    public DateTime LastModified { get; set; }
    public long Size { get; set; }
    public bool HasSubfolder { get; set; }
    public string Name { get; set; }
    public string Ext { get; set; }
    public string Path { get; set; }
}

public class FileExplorerController : Controller
{
    bool HasSubfolder(string path)
    {
        try
        {
            IEnumerable<string> subfolders = Directory.EnumerateDirectories(path);
            return subfolders != null && subfolders.Any();
        }
        catch
        {
            return false;
        }
    }
    List<FileItemModel> GetChildren(string path)
    {
            List<FileItemModel> files = new List<FileItemModel>();

            DirectoryInfo di = new DirectoryInfo(path);

            foreach (DirectoryInfo dc in di.GetDirectories())
            {
                files.Add(new FileItemModel()
                {
                    Name = dc.Name,
                    Path = dc.FullName,
                    IsDirectory = true,
                    HasSubfolder =HasSubfolder(dc.FullName),
                    LastModified=dc.LastWriteTime
                });
            }

            foreach (FileInfo fi in di.GetFiles())
            {
                files.Add(new FileItemModel()
                {
                    Name = fi.Name,
                    Ext = fi.Extension.Length > 1 ? fi.Extension.Substring(1).ToLower() : "",
                    Path = fi.FullName,
                    IsDirectory = false,
                    LastModified = fi.LastWriteTime,
                    Size = fi.Length
                });
            }
            return files;
        }
    }
    public ActionResult GetPath(string path)
    {
        path = Server.UrlDecode(path);
        path = path.Replace("|", ":");
        List<dynamic> result = new List<dynamic>();
        if (path == "/")
        {
            var allDrives = DriveInfo.GetDrives();
            foreach (var drive in allDrives)
            {
                result.Add(new
                {
                    label = drive.Name,
                    path = drive.RootDirectory.FullName.Replace(":", "|"),
                    isDrive = true,
                    isFolder = true,
                    hasSubfolder = HasSubfolder(drive.RootDirectory.FullName),
                    subitems=new string[] { "Total: " + drive.TotalSize.ToString("n0"), "Free: " + drive.AvailableFreeSpace.ToString("n0") }
                });
            }
        }
        else if (Directory.Exists(path))
        {
            List<FileItemModel> content = GetChildren(path);
            foreach (var item in content)
            {
                result.Add(new
                {
                    label = item.Name,
                    path = item.Path.Replace(":", "|"),
                    ext = item.Ext,
                    isFolder = item.IsDirectory,
                    hasSubfolder = item.HasSubfolder,
                    subitems = new string[] { item.LastModified.ToString(), item.IsDirectory ? "" : item.Size.ToString("n0") }
                });
            }
        }
        else if (System.IO.File.Exists(path))
        {
            try
            {
                var rules = System.IO.File.GetAccessControl(path).GetAccessRules(true, true, typeof(System.Security.Principal.SecurityIdentifier));
                foreach (FileSystemAccessRule rule in rules)
                {
                    if ((FileSystemRights.Read & rule.FileSystemRights) == FileSystemRights.Read)
                    {
                        return File(path, System.Net.Mime.MediaTypeNames.Application.Octet, Path.GetFileName(path));
                    }
                }
                return PartialView("Error", "Access Denied: " + path);
            }
            catch (Exception ex)
            {
                return PartialView("Error", "Access Denied: " + path);
            }
        }

        HttpContext.Response.Headers.Add("Access-Control-Allow-Origin", "*");
        return Json(result, JsonRequestBehavior.AllowGet);
    }
}