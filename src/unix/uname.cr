module System
  lib LibC
    CTL_HW = 6
    HW_MODEL = 2

    struct Uname
      sysname : ::LibC::Char[256]
      nodename : ::LibC::Char[256]
      release : ::LibC::Char[256]
      version : ::LibC::Char[256]
      machine : ::LibC::Char[256]
    end

    # The core language has a c/sysctl lib, but not for Macs yet.

    fun uname(value : Uname*) : Int32
    fun sysctl(name : Int32*, namelen : UInt32, oldp : Void*, oldlenp : ::LibC::SizeT*, newp : Void*, newlen : ::LibC::SizeT) : Int32
  end

  struct Uname
    getter cstruct

    def initialize(@cstruct : LibC::Uname)
    end

    macro get(*props)
      {% for prop in props %}
        def {{prop}}
          String.new(cstruct.{{prop}}.to_unsafe)
        end
      {% end %}
    end

    get sysname, nodename, release, version, machine
  end

  # Returns a `System::Uname` struct that has the following members:
  #
  # * sysname
  # * nodename
  # * release
  # * version
  # * machine
  #
  def self.uname : System::Uname
    uname_struct = LibC::Uname.new

    if LibC.uname(pointerof(uname_struct)) < 0
      raise RuntimeError.from_errno("uname")
    else
      Uname.new(uname_struct)
    end
  end

  # Returns the operating system name.
  #
  def self.sysname : String
    uname.sysname
  end

  # Returns the nodename, i.e. the name it's known by on the network.
  # Typically identical to the hostname.
  #
  def self.nodename : String
    uname.nodename
  end

  # Returns the operating system release.
  #
  def self.release : String
    uname.release
  end

  # Returns the operating system version.
  #
  def self.version : String
    uname.version
  end

  # Returns the machine hardware name.
  #
  def self.machine : String
    uname.machine
  end

  # Returns the hardware model name.
  #
  def self.model : String
    {% if flag?(:darwin) %}
      mib = Int32[LibC::CTL_HW, LibC::HW_MODEL]
      buf = Bytes.new(64)
      size = ::LibC::SizeT.new(buf.size)

      if LibC.sysctl(mib, 2, buf, pointerof(size), nil, 0) < 0
        raise RuntimeError.from_errno("sysctl")
      end

      String.new(buf)[0, size - 1]
    {% else %}
      raise "the model method is unsupported on this platform"
    {% end %}
  end
end
